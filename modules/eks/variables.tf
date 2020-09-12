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