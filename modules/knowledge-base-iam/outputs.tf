output "bedrock_role_arn" {
  description = "ARN of the Bedrock IAM role"
  value       = aws_iam_role.bedrock_kb_prt_role.arn
}

output "bedrock_role_name" {
  description = "Name of the Bedrock IAM role"
  value       = aws_iam_role.bedrock_kb_prt_role.name
}