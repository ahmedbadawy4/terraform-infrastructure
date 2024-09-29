module "vpc" {
  source      = "./../modules/vpc"
  aws_region  = var.aws_region
  environment = var.environment
}

module "eks" {
  source              = "./../modules/eks"
  aws_region          = var.aws_region
  environment         = var.environment
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  authentication_mode = "API_AND_CONFIG_MAP"
  subnet_ids          = module.vpc.private_subnets
  eks_managed_node_groups = {
    default = {
      ami_type       = var.ami_type
      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
    }
  }
  access_entries = {
    admin = {
      kubernetes_groups = ["masters"]
      principal_arn     = var.admin_principal_arn
      policy_associations = {
        admin_access = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterPolicy"
          access_scope = {
            namespaces = var.admin_access_scope
            type       = "namespace"
          }
        }
      }
    }
    developer = {
      kubernetes_groups = ["dev-group"]
      principal_arn     = var.developer_principal_arn
      policy_associations = {
        admin_access = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = var.developer_access_scope
            type       = "namespace"
          }
        }
      }
    }
  }
}
