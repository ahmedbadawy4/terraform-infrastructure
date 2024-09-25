data "aws_availability_zones" "available" {}

locals {
  vpc_name = join("-", [var.environment, "vpc"])
}
