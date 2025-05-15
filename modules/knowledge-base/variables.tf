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

variable "bedrock_role_arn" {
  type        = string
  description = "The ARN of the Bedrock role"
}

variable "bedrock_role_name" {
  type        = string
  description = "The name of the Bedrock role"
}

variable "kb_model_arn" {
  type        = string
  description = "The ARN of the Knowledge Base model"
  #default     = "amazon.titan-embed-text-v2:0"
}

variable "opensearch_arn" {
  type        = string
  description = "The ARN of the OpenSearch domain"
}

variable "opensearch_index_name" {
  type        = string
  description = "The name of the OpenSearch index"
}

variable "s3_inclusion_prefixes" {
  type        = list(string)
  description = "List of S3 prefixes that define the object containing the data sources."
  default     = ["skyops"]  
}

variable "agent_id" {
  description = "The agent id"
  type        = string 
}

variable "kb_description" {
  description = "The Knowledge Base description"
  type        = string 
}

variable "agent_identifier_name" {
  type = string
}
