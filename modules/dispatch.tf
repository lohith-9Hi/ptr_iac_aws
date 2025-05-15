# variable "agent_identifier_name" {}
# variable "components" {
#   type = list(string)
# }

module "ec2" {
  source = "./ec2"
  count  = contains(var.components, "EC2") ? 1 : 0
  agent_identifier_name = var.agent_identifier_name
  subnet_id           = var.subnet_id
  instance_type      = var.instance_type
  ami_id           = var.ami_id
}

module "s3" {
  source = "./s3"
  count  = contains(var.components, "S3") ? 1 : 0
  agent_identifier_name = var.agent_identifier_name
  s3_bucket_name      = var.s3_bucket_name
}

module "ecr" {
  source = "./ecr"
  count  = contains(var.components, "ECR") ? 1 : 0
  agent_identifier_name = var.agent_identifier_name
  ecr_repo_name       = var.ecr_repo_name
}

module "eks" {
  source = "./eks"
  count  = contains(var.components, "EKS") ? 1 : 0
  agent_identifier_name = var.agent_identifier_name
  eks_cluster_name   = var.eks_cluster_name
  eks_subnet_ids   = var.eks_subnet_ids
  eks_vpc_id      = var.eks_vpc_id
  eks_desired_size = var.eks_desired_size
  eks_min_size     = var.eks_min_size
  eks_max_size     = var.eks_max_size
}

# Yet to be implemented modules sqs, bedrock, cloudfront

# module "sqs" {
#   source = "./sqs"
#   count  = contains(var.components, "SQS") ? 1 : 0
#   agent_identifier_name = var.agent_identifier_name
# }

# module "bedrock" {
#   source = "./bedrock"
#   count  = contains(var.components, "Bedrock") ? 1 : 0
#   agent_identifier_name = var.agent_identifier_name
# }

# module "cloudfront" {
#   source = "./cloudfront"
#   count  = contains(var.components, "CloudFront") ? 1 : 0
#   agent_identifier_name = var.agent_identifier_name
# }
