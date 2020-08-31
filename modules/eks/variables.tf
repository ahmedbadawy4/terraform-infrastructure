variable "NAME" {
  #default = "eks-cluster"
  description = "Cluster name"
}
variable "max_size" {
  description = "max_size"
  #default     = "2"
}

variable "min_size" {
  description = "min_size"
  #default     = "1"
}

variable "SUBNET_IDS" {
  description = "subnet_ids"
}

variable "INSTANCE_TYPE" {
  description = "instance type and size"
}

variable "WORKER_KEY" {
  description = "instance type and size"
}

variable "HOSTED-ZONE" {
  description = "hosted zone ID"
}



variable "VPC-IDS" {
  description = "vpc ID"
}

variable "REAGION" {
  description = "reagion name ID"
}



variable "SUBNET_1_ID" {
  description = "SUBNET_1_ID"
}

variable "SUBNET_2_ID" {
  description = "SUBNET_2_ID"
}