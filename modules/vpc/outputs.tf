output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "The private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The public subnets"
  value       = module.vpc.public_subnets
}
