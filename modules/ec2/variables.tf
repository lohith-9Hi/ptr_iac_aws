variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# variable "key_name" {
#   description = "Key pair name for SSH access"
#   type        = string
# }

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ec2 instance"
  type        = string
  default = "vpc-0dd3fa725938886e1"
}

variable "agent_identifier_name" {
  type = string
}
