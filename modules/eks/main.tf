module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "${var.agent_identifier_name}-${var.eks_cluster_name}"
  cluster_version = var.eks_cluster_version
  subnet_ids      = var.eks_subnet_ids
  vpc_id          = var.eks_vpc_id
  create_kms_key           = false
  enable_cluster_creator_admin_permissions = true    
  cluster_encryption_config = []
  enable_irsa = false
  eks_managed_node_groups = {
    default = {
      desired_size = var.eks_desired_size
      max_size     = var.eks_max_size
      min_size     = var.eks_min_size

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = var.tags
}

