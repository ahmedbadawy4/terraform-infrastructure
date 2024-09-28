module "eks" {
  source              = "terraform-aws-modules/eks/aws"
  version             = "~> 20.0"
  cluster_name        = local.cluster_name
  cluster_version     = var.cluster_version
  authentication_mode = var.authentication_mode

  # Cluster endpoint public access
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  # Cluster_addons
  cluster_addons = var.cluster_addons

  # VPC configuration
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = var.instance_types
  }
  # Managed Node Group(s)
  eks_managed_node_groups = var.create_eks_managed_node_groups ? local.eks_managed_node_groups : {}

  # Security groups
  cluster_security_group_name                  = local.cluster_security_group_name
  node_security_group_name                     = local.node_security_group_name
  node_security_group_additional_rules         = local.node_security_group_additional_rules
  node_security_group_enable_recommended_rules = var.node_security_group_enable_recommended_rules

  # Cluster creator access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  # Access entries for teams
  access_entries = var.create_access_entries ? local.cluster_access_entries : {}
}
