variable "environment" {
  description = "the environment name"
  type        = string
}

variable "aws_region" {
  description = "the AWS region"
  type        = string
}

variable "cluster_name" {
  description = "the new cluster name"
  type        = string
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is public access enabled."
  type        = bool
  default     = true
}

variable "cluster_version" {
  description = "the new cluster version"
  type        = string
}

variable "cluster_addons" {
  description = "the new cluster addons"
  type        = map(any)
  default = {
    coredns                = true
    eks-pod-identity-agent = true
    kube-proxy             = true
    vpc-cni                = true
  }
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}

variable "subnet_ids" {
  description = "subnet_ids"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "control_plane_subnet_ids"
  type        = list(string)
  default     = []
}

variable "instance_types" {
  description = "instance types"
  type        = list(string)
  default     = ["m5.xlarge"]
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Indicates whether or not the current caller identity should be added as an administrator to the cluster."
  type        = bool
  default     = true
}

variable "create_access_entries" {
  description = "Indicates whether or not the cluster access should be created."
  type        = bool
  default     = true
}

variable "access_entries" {
  description = <<EOF
  Cluster access entries
  Example:
  access_entries = {
    dev = {
      kubernetes_groups = ["system:masters"]
      principal_arn     = "arn:aws:iam::123456789012:role/developer-role"
      policy_associations = {
        read_only = {
          policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
          access_scope = {
            namespaces = ["dev"]
            type       = "namespace"
          }
        }
      }
    }
    admin = {
      kubernetes_groups = ["system:masters"]
      principal_arn     = "arn:aws:iam::123456789012:role/admin-role"
      policy_associations = {
        admin_access = {
          policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
          access_scope = {
            namespaces = ["*"]
            type       = "namespace"
          }
        }
      }
    }
  }
EOF
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        namespaces = list(string)
        type       = string
      })
    }))
  }))
  default = {}
}

variable "create_eks_managed_node_groups" {
  description = "Indicates whether or not the node groups should be created."
  type        = bool
  default     = true
}

variable "eks_managed_node_groups" {
  description = <<EOF
  Map of EKS managed node groups examples:
    eks_managed_node_groups = {
        main = {
        ami_type       = "AL2023_x86_64_STANDARD" # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
        instance_types = ["m5.large"]
        min_size       = 2
        max_size       = 10
        desired_size   = 2
        }
    }
EOF
  type = map(object({
    ami_type       = string
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
  }))
  default = {}

}

variable "node_security_group_enable_recommended_rules" {
  description = "Indicates whether or not the recommended rules should be added to the node security group."
  type        = bool
  default     = true
}

variable "node_security_group_additional_rules" {
  description = "Additional rules for the node security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "authentication_mode" {
  description = "The authentication mode to use for the cluster. Defaults to IAM."
  type        = string
  default     = "API_AND_CONFIG_MAP"
}
