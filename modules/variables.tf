variable "agent_identifier_name" {}
variable "components" {
  type = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
  default = "subnet-0b5cfdd67820106f0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default = "ami-0f88e80871fd81e91"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default = "s3"
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
  default = "ecr"
}

variable "eks_cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default = "eks"
}

variable "eks_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["subnet-0b5cfdd67820106f0", "subnet-0ea8c650ec7ed6eaf"]
}

variable "eks_vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
  default = "vpc-0dd3fa725938886e1"
}

variable "eks_min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default = 1
}

variable "eks_max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default = 3
}

variable "eks_desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  default = 2
}