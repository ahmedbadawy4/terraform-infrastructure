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

variable "aws_tags" {
  description = "the AWS tags to apply to all resources"
  type        = map(any)
  default     = {}
}

variable "aws_region" {
  description = "the AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair for accessing EC2"
  type        = string
}

variable "atlantis_repo" {
  description = "Your GitHub repository for Atlantis to use"
  type        = string
}

variable "sg_cidr_blocks" {
  description = "CIDR blocks to allow traffic from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
