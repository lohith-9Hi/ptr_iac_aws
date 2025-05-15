resource "aws_iam_role_policy" "bedrock_kb_ptr_kb_model" {
  name = "AmazonBedrockOSSPolicyForKnowledgeBase_${var.agent_identifier_name}_${var.kb_name}"
  role = var.bedrock_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["aoss:*"]
        Effect   = "Allow"
        Resource = [var.opensearch_arn]
      }
    ]
  })
}

resource "time_sleep" "iam_consistency_delay" {
  create_duration = "120s"
  depends_on      = [aws_iam_role_policy.bedrock_kb_ptr_kb_model]
}

resource "aws_bedrockagent_knowledge_base" "ptr_kb" {
  name     = "${var.agent_identifier_name}-${var.kb_name}"
  role_arn = var.bedrock_role_arn
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn =  var.kb_model_arn # "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0" 
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = var.opensearch_arn
      vector_index_name = var.opensearch_index_name
      field_mapping {
        vector_field   = "bedrock-knowledge-base-ptr-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
  depends_on = [time_sleep.iam_consistency_delay, aws_iam_role_policy.bedrock_kb_ptr_kb_model]
}

resource "aws_bedrockagent_data_source" "ptr_bk_agt_ds" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.ptr_kb.id
  name              = "${var.agent_identifier_name}-${var.kb_name}-ds"
  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn = var.s3_arn
      inclusion_prefixes = var.s3_inclusion_prefixes
      #bucket_owner_account_id = var.bucket_owner_account_id
    }
  }
}

resource "aws_bedrockagent_agent_knowledge_base_association" "ptr_bk_agt_kb_association" {
  agent_id             = var.agent_id 
  description          = var.kb_description 
  knowledge_base_id    = aws_bedrockagent_knowledge_base.ptr_kb.id
  knowledge_base_state = "ENABLED"
}