terraform {
  backend "s3" {
    bucket = "terraform-bucket-lu"
    key    = "luminor/terraform.tfstate"
    region = "us-east-1"
  }
}