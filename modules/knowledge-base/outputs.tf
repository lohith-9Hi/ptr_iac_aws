output "kb_id" {
  description = "The ID of the Bedrock Agent Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.ptr_kb.id
}

output "kb_arn" {
  description = "The ARN of the Bedrock Agent Knowledge Base"
  value       = aws_bedrockagent_knowledge_base.ptr_kb.arn
}