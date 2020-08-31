NAME = "eks"
#"Cluster name"
REAGION = "us-west-2"

min_size = "1"
#"Minimum number of worker nodes"
max_size = "2"
#"Maximum number of worker nodes"
VPC_CIDR = "10.0.0.0/16"
#"first availability zone"
AZ_1 = "us-west-2a"

# "subnet for the first Availability Zone"
SUBNET_1_CIDR = "10.0.1.0/24"

#"second availability zone"
AZ_2 = "us-west-2b"

#"subnet for the second Availability Zone"
SUBNET_2_CIDR = "10.0.2.0/24"

# Worker node type 
INSTANCE_TYPE = "t2.medium"

# Worker node key, it should be created before RUnning terraform code
WORKER_KEY = "eks-worker-key"

HOSTED-ZONE = "Z00473132TB88PYQ42RU1"