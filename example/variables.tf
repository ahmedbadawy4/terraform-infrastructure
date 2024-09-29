#################
# Common variables
variable "environment" {
  description = "the environment name"
  type        = string
}

variable "team" {
  description = "the team name"
  type        = string
  default     = "SRE"
}

variable "business_unit" {
  description = "the business unit name"
  type        = string
  default     = "SRE"
}

##################
# EKS variables
variable "aws_region" {
  description = "the AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "the new cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "cluster_version" {
  description = "the new cluster version"
  type        = string
  default     = "1.31"
}

variable "aws_tags" {
  description = "the AWS tags to apply to all resources"
  type        = map(any)
  default     = {}
}

variable "admin_principal_arn" {
  description = "the ARN of the admin role"
  type        = string
}

variable "developer_principal_arn" {
  description = "the ARN of the developer role"
  type        = string
}

variable "developer_access_scope" {
  description = "the access scope for the developer"
  type        = list(string)
  default     = ["development", "staging"]

}

variable "admin_access_scope" {
  description = "the access scope for the admin"
  type        = list(string)
  default     = ["default", "development", "staging", "production"]

}

variable "ami_type" {
  description = "the AMI type"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "instance_types" {
  description = "the instance types"
  type        = list(string)
  default     = ["m5.xlarge"]
}

variable "min_size" {
  description = "the minimum size"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "the maximum size"
  type        = number
  default     = 4
}

variable "desired_size" {
  description = "the desired size"
  type        = number
  default     = 2
}
