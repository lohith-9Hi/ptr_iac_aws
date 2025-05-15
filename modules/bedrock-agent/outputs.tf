
output "agent_id" {
  description = "The ID of the AWS Bedrock Agent."
  value       = aws_bedrockagent_agent.ptr_bedrock_agent.agent_id
}

output "agent_aliases_id" {
  description = "The ID of the AWS Bedrock Agent Aliases."
  value       = aws_bedrockagent_agent_alias.ptr_bedrock_agent_alias.agent_alias_id
}
