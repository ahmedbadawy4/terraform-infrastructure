environment             = "prod"
developer_principal_arn = "<developers SSO iam role arn>"
admin_principal_arn     = "<admin SSO iam role arn>"
eks_managed_node_groups = {
  default = {
    ami_type       = "AL2023_x86_64_STANDARD" ## recommended to use a private ami
    instance_types = ["m5.xlarge"]
    min_size       = 2
    max_size       = 4
    desired_size   = 2
  }
}
