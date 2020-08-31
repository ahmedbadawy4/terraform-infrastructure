terraform {
  backend "s3" {
    bucket = "terraform-bucket-l"
    key    = "luminor/terraform.tfstate"
    region = "us-west-2"
  }
}