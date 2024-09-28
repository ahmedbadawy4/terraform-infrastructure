# Overview

This example provides a Terraform configuration for provisioning a new VPC and Amazon Elastic Kubernetes Service (EKS) cluster on AWS.

## Prerequisites
Before deploying the EKS cluster, ensure you have the following tools installed and configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) (v1.5.0 or higher)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (configured with credentials)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (for managing the Kubernetes cluster)
- [Helm](https://helm.sh/docs/intro/install/) (optional, for deploying applications on the cluster)
- Setup an S3 bucket as a terraform state backend in `config.tf`:

  ```
  terraform {
    backend "s3" {
      bucket = "<bucket_name>"
      key    = "<some_key_path>/terraform.tfstate"
      region = "<region>"
    }
  .....
  }
  ```

### AWS IAM Permissions

You need appropriate AWS IAM permissions to create resources such as:

- EKS cluster
- VPC, subnets, and security groups
- IAM roles and policies
- EC2 instances for worker nodes
  
  *Ensure your AWS credentials are properly set up either via the AWS CLI (`aws configure`) or via environment variables.*

## How to Deploy 

#### 1. Clone the Repository

First, clone this repository to your local machine:

```bash
git clone https://github.com/ahmedbadawy4/terraform-eks.git
cd terraform-eks
```

#### 2. Configure Variables
Each environment variable can be customized by modifying the variables in the `tfvars/<environment>.tfvars` file

```
environment             = <envieronment_name>
developer_principal_arn = "<developers SSO iam role arn>"
admin_principal_arn     = "<admin SSO iam role arn>"
eks_managed_node_groups = {
  default = {
    ami_type       = "node_group_ami_type_of" #better to build your ami template that is customized properly
    instance_types = ["<instance_type>"]
    min_size       = <Min number of instances>
    max_size       = <Max number of instances>
    desired_size   = <Desire number of instances>
  }
}
```
#### 3. Initialize Terraform
Run the following command to initialize Terraform, which will download the necessary modules and provider plugins:

```
terraform init
```

#### 4. Create an Execution Plan
The execution plan shows you what Terraform will do when you apply it. You can create the plan by running:

```
terraform plan --var-file=tfvars/<envieronment_name>.tfvars -out=tfplan -no-color
```
This will generate a plan file tfplan, which you can inspect or save for later use.

#### 5. Apply the Plan
To deploy the EKS cluster and all associated resources, apply the generated plan:

```
terraform apply --var-file=tfvars/<envieronment_name>.tfvars tfplan
```
This command will provision the resources in your AWS account.

#### 6. Configure `kubectl` to Access the EKS Cluster
Once the cluster is successfully created, you can use the AWS CLI to update your kubectl configuration to interact with the new EKS cluster:

```
aws eks --region <region> update-kubeconfig --name <cluster_name>
```
This command configures kubectl to use the EKS cluster you just deployed.

#### 7. Verify the Cluster (Optional)
Use kubectl to verify that the cluster is running and accessible:

```
kubectl get nodes
```
This should display a list of worker nodes if everything was set up correctly.

## How to Destroying the Cluster (all the deployed infra)
If you need to delete all resources created by Terraform, run the following command:

```
terraform destroy --var-file=tfvars/dev.tfvars
```
This will tear down all infrastructure provisioned by this configuration.

## Troubleshooting

If you encounter issues during deployment:

1. Ensure your AWS credentials are configured and have sufficient permissions.
2. Ensure the S3 bucket that works as a backend is configured correctly and the local machine has access to it.
3. Check that your AWS region, VPC, and subnets are correct.
4. Look at the Terraform state and plan output for details on errors.
5. Re-run terraform in debug mood to get more details example `TF_LOG=DEBUG TF_LOG_PATH=terraform_debug.log terraform apply`
6. Ensure the `kubectl` configuration is correctly pointing to the EKS cluster.
