provider "aws" {
  region = var.aws_region
  default_tags {
    tags = merge(
      var.aws_tags,
      {
        "ei:environment" = var.environment,
        "team"           = var.team,
        "business-unit"  = var.business_unit
        "component-name" = var.cluster_name
      }
    )
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-801627643938"
    key    = "luminor-eks/terraform.tfstate"
    region = "eu-west-1"
  }
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
