environment             = "dev"
admin_principal_arn     = "arn:aws:iam::801627643938:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_FullAdministratorAccess_08f8f4689addc90c"
developer_principal_arn = "arn:aws:iam::801627643938:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_AWSReadOnlyAccess_0c9e157e7620b5e0"
eks_managed_node_groups = {
  default = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = ["m5.xlarge"]
    min_size       = 2
    max_size       = 4
    desired_size   = 2
  }
}
