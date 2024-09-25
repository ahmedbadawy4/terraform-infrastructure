locals {
  cluster_name                = join("-", [var.environment, var.cluster_name])
  node_security_group_name    = join("-", [var.environment, var.cluster_name, "node-sg"])
  cluster_security_group_name = join("-", [var.environment, var.cluster_name, "cluster-sg"])
  cluster_access_entries = {
    for entry_key, entry in var.access_entries : entry_key => {
      kubernetes_groups = entry.kubernetes_groups
      principal_arn     = entry.principal_arn
      policy_associations = {
        for policy_key, policy in entry.policy_associations : policy_key => {
          policy_arn   = policy.policy_arn
          access_scope = policy.access_scope
        }
      }
    }
  }
  eks_managed_node_groups = {
    for node_group_key, node_group in var.eks_managed_node_groups : node_group_key => {
      ami_type       = lookup(node_group, "ami_type", "AL2_x86_64")
      instance_types = node_group.instance_types
      min_size       = node_group.min_size
      max_size       = node_group.max_size
      desired_size   = node_group.desired_size
    }
  }
  node_security_group_additional_rules = {
    for idx, rule in var.node_security_group_additional_rules : idx => {
      from_port   = rule.from_port
      to_port     = rule.to_port
      protocol    = rule.protocol
      cidr_blocks = rule.cidr_blocks
    }
  }
}
