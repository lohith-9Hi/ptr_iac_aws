variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "proctor-aws-agent"
}

variable "vpc_cidr" {
  default = "10.232.0.0/24"
}

variable "public_subnet_cidr" {
  default = "10.232.0.0/25"
}

variable "public_subnet_2_cidr" {
  default = "10.232.0.128/25"
}