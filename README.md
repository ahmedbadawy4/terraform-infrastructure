# Overview

This repository provides a Terraform configuration for provisioning an Amazon Elastic Kubernetes Service (EKS) cluster on AWS.

## Repository Structure
  - `.github/workflow/pre-commit.yml`: A Gihub action pipeline that runs when opening/updating a PullRequest to ensure the terraform formatting, linting, validation, etc are valid.
  - `.github/workflow/terraform-pipeline.yaml`: Another Github action pipeline that makes it easy to deploy the terraform. 
  - `modules`: Contains `eks`, and `vpc` modules.
  - `tfvars/dev.tfvars` and `tfvars/prod.tfvars`: Override default variables and contain the spicific environment values for each variable.
  - `pre-commit-config.yaml`: Contains the pre-commit configs and hooks.
  - `config.tf`: Contains the required Terraform provider configuration, AWS Region, and Terraform state backend configurations.
  - `main.tf`: Main Terraform configuration for setting up the EKS cluster.
  - `outputs.tf`: Outputs of the Terraform configuration (such as the cluster endpoint, cluster certificat_authority, etc.).
  - `variables.tf`: Contains the input variables for the Terraform configuration.

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
### A. Using the GitHub action pipeline
*This way is more efficient to run the terraform and ensure the configuration is correct every time we are deploying without any human factor error.*
concurrency group to prevent multiple runs of the same workflow
#### Workflow Overview

The Terraform CI/CD pipeline consists of two main jobs:
1. **Terraform Plan**: This job initializes Terraform, generates a plan, and saves it as an artifact.
2. **Terraform Apply**: This job applies the Terraform plan generated in the previous job.
*it also contains these configurations to ensure quality:*
3. the pipeline has a limited choice to ensure no typo mistakes in the input environment name.
4. the `terraform apply job will run only from the `main` branch assuming it is protected and has the latest valid code`

### Workflow Trigger

The workflow is triggered using the `workflow_dispatch` event, allowing manual execution with the option to specify the target environment (either `dev` or `prod`).

#### Steps:

1. Click on the **Run workflow** button.
2. Select the desired **target environment** from the dropdown options (`dev` or `prod`).
3. Click the **Run workflow** button to start the execution.

### B. using local machine.

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


## (Advanced) steps to use Atlantis
Atlantis is used to automate Terraform workflows via GitHub pull requests (PRs). It listens for changes in the Terraform configuration and automatically runs `terraform plan` and `terraform apply` within PRs based on certain commands.

### Prerequisites

Before using Atlantis, ensure the following are set up:

- Atlantis is deployed and running (usually in a container or Kubernetes).
- Atlantis has access to your GitHub repository via a webhook and appropriate access permissions.
- Your Terraform codebase is compatible with Atlantis.

### Steps to Use Atlantis

1. **Install and Deploy Atlantis**

   Atlantis can be deployed in multiple ways, such as on **Kubernetes**, **Docker**, or directly on a virtual machine. If you haven’t already set up Atlantis, follow the installation instructions in the [official Atlantis documentation](https://www.runatlantis.io/docs/install.html).

2. **Configure Atlantis in Your Repository**

   Ensure your repository has a valid `atlantis.yaml` file to define your Atlantis configuration. Here's an example configuration file:

   ```yaml
   version: 3
   projects:
     - name: my-eks-cluster
       dir: .
       workflow: default
       autoplan:
         when_modified: ["*.tf", "*.tfvars"]
         enabled: true
    ```
  `dir`: Specifies the directory where your Terraform files are located (in this case, the root directory).
  `autoplan`: Automatically runs terraform plan when a .tf or .tfvars file is modified.

3. **Set Up the GitHub Webhook**

To automate the Terraform runs, you need to create a webhook in your GitHub repository that points to your Atlantis server. Follow these steps:

  - Navigate to your repository on GitHub.
  - Go to Settings > Webhooks > Add webhook.
  - Set the payload URL to point to your Atlantis server, e.g., http://<your-atlantis-url>/events.
  - Set the content type to application/json.
  - Choose "Let me select individual events" and select Pull Requests and Push events.
  - Save the webhook.

4. **Using Atlantis in Pull Requests**
Once Atlantis is set up and connected, the following steps describe how to use it:

  - Open a Pull Request (PR): When a pull request that modifies .tf files is created, Atlantis will automatically run the terraform plan and post the result in the PR.

  - Running Terraform Plan: When a pull request is opened, Atlantis runs the Terraform plan automatically and posts the plan result as a comment on the PR. You can also manually trigger a plan by commenting on the PR:

```
atlantis plan
```
  - Running Terraform Apply: After reviewing the plan, you can trigger Terraform Apply by commenting on the pull request:

```
atlantis apply
```
  - Auto-Plan and Auto-Apply: If autoplan is enabled in your `atlantis.yaml` configuration, Atlantis will automatically run the plan when changes are detected. The apply step still requires approval via a comment.

5. **Merge the Pull Request**
Once the Terraform plan is successfully applied and everything looks good, the pull request can be merged. Atlantis ensures that your infrastructure changes are deployed only after the `atlantis apply` command is approved and successfully executed.


#### Atlantis Commands in Pull Requests
Here are some useful Atlantis commands you can run directly within PR comments:

  - `atlantis plan`: Runs `terraform plan` and posts the output in the PR.
  - `atlantis apply`: Runs `terraform apply` and applies the Terraform changes.
  - `atlantis unlock`: Unlocks a PR that is locked by an incomplete plan or apply.
  - `atlantis help`: Provides a list of available commands.

## To-do list
- Create a custom AMI image that is customized and configured with the necessary configurations.
- Create Self hosted runner to be used in the GitHub actions
- we could use an opsnSSL command to encrypt the tfplan to ensure the security of the plan file when has been uploaded as an artifact to Github.
- Create another repository that uses terragrunt to deploy the eks, vpc modules, and other resources.
