variable "eks_cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

variable "eks_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "eks_vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "eks_desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
  
}

variable "eks_min_size" {
  description = "Minimum size of the EKS node group"
  type        = number 
}

variable "eks_max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  
}

variable "agent_identifier_name" {
  type = string
}