data "aws_iam_policy" "lambda_basic_execution" {
  name = "AWSLambdaBasicExecutionRole"
}

#Action group Lambda execution role
resource "aws_iam_role" "ptr_action_lambda_role" {
  name = "FunctionExecutionRoleForLambda_${var.action_group_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
 # managed_policy_arns = [data.aws_iam_policy.lambda_basic_execution.arn]
}

# Attach the policy to the role (using the policy ARN)
resource "aws_iam_role_policy_attachments_exclusive" "ptr_lambda_role_policy_attachment" { 
  role_name    = aws_iam_role.ptr_action_lambda_role.name
  policy_arns  = [data.aws_iam_policy.lambda_basic_execution.arn] 
}


# Action group Lambda function
resource "aws_lambda_function" "ptr_action_lambda" {
  function_name     = var.action_group_name
  role              = aws_iam_role.ptr_action_lambda_role.arn
  description       = "A Lambda function for the action group ${var.action_group_name}"
  filename          = var.filename_path # data.archive_file.prt_action_lambda_zip.output_path
  handler           = "${var.action_group_name}.lambda_handler"
  runtime           = "python3.12" 
  source_code_hash  = var.source_code_hash  # data.archive_file.prt_action_lambda_zip.output_base64sha256
  # tracing_config {
  #   mode = "Active"
  # }
#   vpc_config {
#     subnet_ids         = var.subnet_ids
#     security_group_ids = var.security_group_ids
#   }
}

resource "aws_lambda_permission" "ptr_action_lambda_permission_bedrock" {
  action         = "lambda:invokeFunction"
  function_name  = aws_lambda_function.ptr_action_lambda.function_name
  principal      = "bedrock.amazonaws.com"
  source_account = local.account_id
  source_arn     = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:agent/*"
}

resource "aws_lambda_permission" "ptr_action_lambda_permission_apigateway" {
  action         = "lambda:invokeFunction"
  function_name  = aws_lambda_function.ptr_action_lambda.function_name
  principal      = "apigateway.amazonaws.com"
  source_account = local.account_id
  source_arn     = "arn:aws:execute-api:${local.region}:${local.account_id}:*"
}

resource "aws_bedrockagent_agent_action_group" "ptr_lambda_bedrock_action_group" {
  action_group_name          = var.action_group_name
  agent_id                   = var.agent_id
  agent_version              = "DRAFT"
  description                = var.action_group_desc
  skip_resource_in_use_check = true
  action_group_executor {
    lambda = aws_lambda_function.ptr_action_lambda.arn
  }
  api_schema {
    payload = var.payload_file #file("${path.module}/lambda/error_rca_api/rca-openapi.yml")
  }
}
