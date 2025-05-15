resource "aws_ecr_repository" "this" {
  name                 = "${var.agent_identifier_name}-${var.ecr_repo_name}"
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}