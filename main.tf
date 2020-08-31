module "vpc" {
  source        = "./modules/vpc"
  AZ_1          = var.AZ_1
  AZ_2          = var.AZ_2
  SUBNET_2_CIDR = var.SUBNET_2_CIDR
  SUBNET_1_CIDR = var.SUBNET_1_CIDR
  VPC_CIDR      = var.VPC_CIDR
}

module "eks" {
  source     = "./modules/eks"
  VPC-IDS     = module.vpc.VPC-ID
  REAGION     = var.REAGION
  min_size   = var.min_size
  max_size   = var.max_size
  NAME       = var.NAME
  INSTANCE_TYPE = var.INSTANCE_TYPE
  WORKER_KEY = var.WORKER_KEY
  SUBNET_IDS = module.vpc.SUBNET_IDS
  HOSTED-ZONE = var.HOSTED-ZONE
  SUBNET_1_ID = module.vpc.subnet1_id
  SUBNET_2_ID = module.vpc.subnet2_id
 }