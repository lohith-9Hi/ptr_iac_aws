resource "aws_s3_bucket" "fnol_bucket" {
  bucket = "${var.agent_identifier_name}-${var.s3_bucket_name}"
  acl    = var.acl
}
