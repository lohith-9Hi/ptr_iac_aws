data "aws_iam_policy" "lambda_basic_execution" {
  name = "AWSLambdaBasicExecutionRole"
}

#Action group Lambda execution role
resource "aws_iam_role" "ptr_lambda_role" {
  name = "FunctionExecutionRoleForLambda_${var.agent_identifier_name}_${var.lambda_name}"
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

  depends_on = [aws_iam_policy.ptr_lambda_iam_policy]
}


# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

data "aws_iam_policy_document" "ptr_lambda_iam_policy_doc" {
  statement {
    sid = "logsStmt"

    actions = [
      "logs:CreateLogGroup", 
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}::log-group:/aws/lambda/ptr-skyops-bedrock-api:*",
    ]
  }

  statement {
    sid = "bedrockStmt"

    actions = [
      "bedrock:RetrieveAndGenerate",
      "bedrock:InvokeModel",
      "bedrock:InvokeAgent",
      "bedrock:GetAgentAlias",
      "bedrock:AssociateThirdPartyKnowledgeBase",
      "bedrock:ApplyGuardrail",
      "bedrock:Retrieve",
      "bedrock:StartIngestionJob",
      "bedrock:ListFoundationModels"
    ]

    resources = [
      "arn:aws:bedrock:${local.region}:${local.account_id}:agent-alias/*",
      "arn:aws:bedrock:${local.region}:${local.account_id}:agent/*",
    ]
  }
}


resource "aws_iam_policy" "ptr_lambda_iam_policy" {
  name        = "ptr-lambda-iam-policy"
  description = "Protor lambda IAM Polcy"
  policy = data.aws_iam_policy_document.ptr_lambda_iam_policy_doc.json
  
  lifecycle {
    create_before_destroy = true
  } 

}


# Attach the policy to the role (using the policy ARN)
# resource "aws_iam_role_policy_attachment" "ptr_lambda_role_policy_attachment" { 
#   role       = aws_iam_role.ptr_lambda_role.name
#   policy_arn = aws_iam_policy.ptr_lambda_iam_policy.arn  # Use the ARN of the policy
# }


# Attach the policy to the role (using the policy ARN)
resource "aws_iam_role_policy_attachments_exclusive" "ptr_lambda_role_policy_attachment" { 
  role_name    = aws_iam_role.ptr_lambda_role.name
  policy_arns  = [data.aws_iam_policy.lambda_basic_execution.arn, aws_iam_policy.ptr_lambda_iam_policy.arn] 
}

# Action group Lambda function
resource "aws_lambda_function" "ptr_lambda" {
  function_name     = "${var.agent_identifier_name}-${var.lambda_name}"
  role              = aws_iam_role.ptr_lambda_role.arn
  description       = "A Lambda function for the action group ${var.agent_identifier_name} ${var.lambda_name}"
  filename          = var.filename_path
  handler           = "${var.agent_identifier_name}-${var.lambda_name}.lambda_handler"
  runtime           = "python3.12"
  source_code_hash  = var.source_code_hash
  timeout           = 180
  environment {
    variables = {
      bedrock_agent_id =  var.bedrock_agent_id 
      bedrock_agent_alias_id = var.bedrock_agent_alias_id
    }
  }
  # tracing_config {
  #   mode = "Active"
  # }
#   vpc_config {
#     subnet_ids         = var.subnet_ids
#     security_group_ids = var.security_group_ids
#   }
}

# API Gateway
resource "aws_api_gateway_rest_api" "ptr_api" {
  name = var.rest_api_name
}

resource "aws_api_gateway_resource" "ptr_resource" {
  path_part   = var.rest_api_name
  parent_id   = aws_api_gateway_rest_api.ptr_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.ptr_api.id
}

resource "aws_api_gateway_method" "ptr_method" {
  rest_api_id   = aws_api_gateway_rest_api.ptr_api.id
  resource_id   = aws_api_gateway_resource.ptr_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ptr_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ptr_api.id
  resource_id             = aws_api_gateway_resource.ptr_resource.id
  http_method             = aws_api_gateway_method.ptr_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.ptr_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "ptr_response_200" {
  rest_api_id = "${aws_api_gateway_rest_api.ptr_api.id}"
  resource_id = "${aws_api_gateway_resource.ptr_resource.id}"
  http_method = "${aws_api_gateway_method.ptr_method.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}  

resource "aws_api_gateway_integration_response" "ptr_integration_response" {
  rest_api_id = "${aws_api_gateway_rest_api.ptr_api.id}"
  resource_id = "${aws_api_gateway_resource.ptr_resource.id}"
  http_method = "${aws_api_gateway_method.ptr_method.http_method}"
  status_code = "${aws_api_gateway_method_response.ptr_response_200.status_code}" 
  response_templates = {
    "application/json" = ""
   }
  
  depends_on = [
    aws_api_gateway_integration.ptr_integration
  ] 

}

# Lambda
resource "aws_lambda_permission" "ptr_apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ptr_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_api_gateway_rest_api.ptr_api.id}/*/${aws_api_gateway_method.ptr_method.http_method}${aws_api_gateway_resource.ptr_resource.path}"
}

resource "aws_api_gateway_deployment" "prt_deployment" { 
  rest_api_id = aws_api_gateway_rest_api.ptr_api.id
  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.ptr_resource.id,
      aws_api_gateway_method.ptr_method.id,
      aws_api_gateway_integration.ptr_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
} 


resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.prt_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.ptr_api.id
  stage_name    = "cap"
}



