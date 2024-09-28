terraform {
  source = "${get_repo_root()}/modules/eks"
}

dependency "vpc" {
  config_path = "${get_path_to_repo_root()}//aws/dev/vpc"
}

include {
  path = find_in_parent_folders()
}


locals {
  account_vars     = yamldecode(file(find_in_parent_folders("account.yaml", find_in_parent_folders("empty.yaml"))))
  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml", find_in_parent_folders("empty.yaml"))))
  config_vars      = yamldecode(file(find_in_parent_folders("config.yaml", find_in_parent_folders("empty.yaml"))))
}

inputs = {
  aws_region          = var.aws_region
  environment         = local.environment_vars.environment
  cluster_name        = local.config_vars.cluster_name
  cluster_version     = local.config_vars.cluster_version
  vpc_id              = dependency.vpc.outputs.vpc_id
  authentication_mode = local.config_vars.authentication_mode
  subnet_ids          = dependency.vpc.outputs.private_subnets
  access_entries      = local.config_vars.access_entries
  eks_managed_node_groups = {
    default = {
      ami_type       = local.config_vars.ami_type
      instance_types = local.config_vars.instance_types
      min_size       = local.config_vars.min_size
      max_size       = local.config_vars.max_size
      desired_size   = local.config_vars.desired_size
    }
  }
}
