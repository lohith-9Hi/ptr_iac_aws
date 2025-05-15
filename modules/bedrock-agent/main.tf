data "aws_caller_identity" "this" {}

data "aws_partition" "this" {}

data "aws_region" "this" {}

data "aws_bedrock_foundation_model" "this" {
  model_id = var.model_id
}


data "aws_iam_policy_document" "ptr_agent_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["bedrock.amazonaws.com"]
      type        = "Service"
    }
    condition {
      test     = "StringEquals"
      values   = [data.aws_caller_identity.this.account_id]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:${data.aws_partition.this.partition}:bedrock:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:agent/*"]
      variable = "AWS:SourceArn"
    }
  }
}

data "aws_iam_policy_document" "ptr_agent_permissions" {
  statement {
    actions = ["bedrock:InvokeModel"]
    resources = [
      "arn:${data.aws_partition.this.partition}:bedrock:${data.aws_region.this.name}::foundation-model/${data.aws_bedrock_foundation_model.this.model_id}",
    ]
  }
}

resource "aws_iam_role" "ptr_agent_role" {
  assume_role_policy = data.aws_iam_policy_document.ptr_agent_trust.json
  name_prefix        = "BedrockExecRoleForAgents_${var.agent_identifier_name}"
}

resource "aws_iam_role_policy" "ptr_agent_role_policy" {
  policy = data.aws_iam_policy_document.ptr_agent_permissions.json
  role   = aws_iam_role.ptr_agent_role.id
}
 
resource "aws_bedrockagent_agent" "ptr_bedrock_agent" {
  agent_name                  = var.agent_identifier_name
  agent_resource_role_arn     = aws_iam_role.ptr_agent_role.arn
 # idle_session_ttl_in_seconds = 500
  description                 = var.agent_desc
  foundation_model            = data.aws_bedrock_foundation_model.this.model_id
  instruction                 = var.agent_instruction
}

resource "aws_bedrockagent_agent_alias"  "ptr_bedrock_agent_alias" { 
  agent_alias_name = "${var.agent_identifier_name}-alias"
  agent_id         = aws_bedrockagent_agent.ptr_bedrock_agent.agent_id
  description      = "${var.agent_identifier_name}-${var.agent_alias_description}" 
}