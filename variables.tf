variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public-a_subnet_cidr" {
  description = "CIDR for the Public Subnet in AZ-a"
  default     = "10.0.0.0/24"
}

variable "public-b_subnet_cidr" {
  description = "CIDR for the Public Subnetc in AZ-b"
  default     = "10.0.1.0/24"
}