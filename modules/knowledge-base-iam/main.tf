resource "aws_iam_role" "bedrock_kb_prt_role" {
  name = "AmazonBedrockExecutionRoleForKnowledgeBase_${var.agent_identifier_name}_${var.kb_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:${local.partition}:bedrock:${local.region}:${local.account_id}:knowledge-base/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_kb_ptr_policy" {
  name = "AmazonBedrockFoundationModelPolicyForKnowledgeBase_${var.agent_identifier_name}_${var.kb_name}"
  role = aws_iam_role.bedrock_kb_prt_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "bedrock:InvokeModel"
        Effect   = "Allow"
        Resource = var.kb_model_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_kb_ptr_s3_policy" {
  name = "AmazonBedrockS3PolicyForKnowledgeBase_${var.agent_identifier_name}_${var.kb_name}"
  role = aws_iam_role.bedrock_kb_prt_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "S3ListGetPutObjectStatement"
        Action   = ["s3:List*", "s3:Get*", "s3:PutObject"]
        Effect   = "Allow"
        Resource = [var.s3_arn,  "${var.s3_arn}/*"]
        Condition = {
          StringEquals = {
            "aws:PrincipalAccount" = local.account_id
          }
      } },
      {
        Sid      = "KMSPermissions"
        Action   = ["kms:*"]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}