variable "VPC_CIDR" {
  description = "CIDR for vpc"
}
variable "SUBNET_1_CIDR" {
  description = "subnet for the first Availability Zone"
}

variable "SUBNET_2_CIDR" {
  description = "subnet for the second Availability Zone"
}

variable "AZ_1" {
  description = "first Availability Zone"
}

variable "AZ_2" {
  description = "second Availability Zone"
}
