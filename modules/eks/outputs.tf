output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificat_authority" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}
