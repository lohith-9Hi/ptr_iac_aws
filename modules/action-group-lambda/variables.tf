variable "action_group_name" {
  type        = string
  description = "The name of the action group for monitoring alerts."
}

variable "action_group_desc" {
  type        = string
  description = "The name of the action group description."
}

# variable "lambda_role_arn" {
#   type        = string
#   description = "The Amazon Resource Name (ARN) of the IAM role for the Lambda function."
# }
variable "agent_id" {
  description = "The agent id"
  type        = string 
}

variable "filename_path" {
  type        = string
  description = "Lambda Source Code archive_file path"
}

variable "payload_file" {
  type        = string
  description = "The API schema file"
}

variable "source_code_hash" {
  type        = string
  description = "Lambda Source Code archive_file Hash"
}

variable "agent_identifier_name" {
  type = string
}

# variable "subnet_ids" {
#   type        = list(string)
#   description = "The list of subnet IDs where the Lambda function will be deployed."
# }

# variable "security_group_ids" {
#   type        = list(string)
#   description = "The list of security group IDs to be associated with the Lambda function."
# }