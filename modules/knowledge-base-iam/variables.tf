variable "kb_name" {
  type        = string
  description = "The name of the Knowledge Base"
  #default     = "ptr-kb-skyops"
}

variable "s3_arn" {
  type        = string
  description = "The ARN of the S3 bucket"
  #default     = "arn:aws:s3:::cap-ptr-test-bucket/skyops/"
}

variable "kb_model_arn" {
  type        = string
  description = "The ARN of the Knowledge Base model"
  #default     = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
  #default      = "amazon.titan-embed-text-v1"
}

variable "agent_identifier_name" {
  type = string
}