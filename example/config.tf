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
    bucket = "<bucket_name>"
    key    = "<some_key_path>/terraform.tfstate"
    region = "<region>"
    secret_key = "<secret_key>"
    dynamodb_table = "<dynamodb_table_name>"
  }
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
