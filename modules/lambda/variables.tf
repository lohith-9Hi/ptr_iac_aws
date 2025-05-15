variable "lambda_name" {
  type        = string
  description = "The name of the lambda."
}
 
variable "filename_path" {
  type        = string
  description = "Lambda Source Code archive_file path"
}
 
variable "source_code_hash" {
  type        = string
  description = "Lambda Source Code archive_file Hash"
}

variable "rest_api_name" {
  type        = string
  description = "The rest api name"
}

variable "bedrock_agent_id" {
  type        = string
  description = "Bedrock Agent ID"
}

variable "bedrock_agent_alias_id" {
  type        = string
  description = "Bedrock Agent Alias ID"
}

variable "agent_identifier_name" {
  type = string
}