remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-state-801627643938"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "eu-west-1"
    #    dynamodb_table               = "terragrunt-locks"
  }
}

locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
}


#iam_role = "arn:aws:iam::197257905927:role/terragrunt-role"
