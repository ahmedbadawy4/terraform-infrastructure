output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_certificat_authority" {
  value = module.eks.eks_cluster_certificat_authority
}