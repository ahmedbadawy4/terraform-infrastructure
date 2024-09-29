remote_state {
  backend = "s3"
  config = {
    bucket         = "<bucket_name>"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "<aws_region>"
    dynamodb_table = "<terragrunt-locks-table>"
  }
}

locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
}
