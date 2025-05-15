# output "distribution_ids" {
#   value = { for k, v in aws_cloudfront_distribution.this : k => v.id }
# }

# output "distribution_domain_names" {
#   value = { for k, v in aws_cloudfront_distribution.this : k => v.domain_name }
# }