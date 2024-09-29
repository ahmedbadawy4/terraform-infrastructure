# Overview

This repository provides a Terraform configuration for provisioning an Amazon Elastic Kubernetes Service (EKS) cluster on AWS.

## Repository Structure
  - [Atlantis Server](./atlantis-server/): Atlantis server configurations to automate provision Ec2 instance using terraform and Configure the server using ansible.
  - [Gihub action pipeline](./.github/workflows/pre-commit.yaml) that runs when opening/updating a PullRequest to ensure the terraform formatting, linting, validation, etc are valid.
  - [Infra pipeline](./.github/workflow/infra-pipeline.yaml): Another Github action pipeline that makes it easy to directly trigger infrastructure deployment. 
  - [Terraform modules](modules): Contains `eks`, and `vpc` modules. *modules should be in a diffrent repo to handle the module versions using GitHub tags.*
  - [pre-commit configurations](./pre-commit-config.yaml): (Documentation)[https://pre-commit.com/] Contains the pre-commit configs and hooks.
  - [Terragrunt code](./aws): Contains the Terragrunt configuration for two environments sharing one s3 backend, each environment can be deployed in diffrent or the same AWS account (current setup is diffrent accounts).

## Prerequisites
Before deploying the EKS cluster, ensure you have the following tools installed and configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) (v1.5.0 or higher)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)(v0.67.14 or higher)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (configured with credentials)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (for managing the Kubernetes cluster)
- [Helm](https://helm.sh/docs/intro/install/) (optional, for deploying applications on the cluster)

- Setup Atlantis Server in two steps after complete the requirement inputs in the `atlantis-playbook.yaml` file:
  - make atlantis-infra
  - make atlantis-config

- Setup an S3 bucket as a terraform state backend in [Terragrunt backend config](./aws/terragrunt.hcl):

  ```
  remote_state {
  backend = "s3"
  config = {
    bucket = "<bucket_name>"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "<aws_region>"
    dynamodb_table  = "<terragrunt-locks-table>"
    }
  }
  ```
- Complete the Terragrunt configurations by adding the following in each environment `account.yaml`:
  - aws_region: "<aws-region>"
  - aws_account_id: "<aws-account-id>"
  - account_name: "<account-name>"
- Complete each resource config in `config.yaml`

## How to Deploy 
### A. Using the GitHub action pipeline
*Notes: the pipeline is a proof of concept it should cover more cases than just applying the infra*

* This way is more efficient to directly deploy the environment.
* concurrency group to prevent multiple runs of the same workflow as an extra step to lock state file.
* It must use a self-hosted runner that has access to the AWS accounts and can manage the infra.

#### Workflow Overview

The infra CI/CD pipeline consists of one main job:
1. **terragrunt**: This job initializes and initializes the necessary components, initializes, generates, and applies.

*Notes:
it is possible to run this job in a GitHub environment which requires approvals in case of deploying to prod. tis can be achived by creating two GitHub environments and setting the desired configuration to each one.*

3. The pipeline has a limited choice to ensure no typo mistakes in the input environment name.

### Workflow Trigger

[The workflow](https://github.com/ahmedbadawy4/terraform-infrastructure/actions/workflows/infra-pipeline.yaml) is triggered using the `workflow_dispatch` event, allowing manual execution with the option to specify the target environment (example `aws/dev/vpc` to deploy the vpc in the dev environment).

### Using Atlantis

[Atlantis](https://www.runatlantis.io/) is a tool for automating Terraform and Terragrunt workflows using pull requests (PRs). With Atlantis, infrastructure changes are deployed automatically when PRs are merged into specific branches, ensuring a consistent and automated CI/CD pipeline for infrastructure management.

*Important notes: Terragrunt and atlantis required respect of the infra dependencies order in creating/changing/deleting the resources.*
*Example: the VPC needs to be deployed before the EKS.*

#### Steps to Use Atlantis with Terragrunt

1. **Setup Atlantis**

   Ensure that Atlantis is configured and running on your infrastructure. You can either:
   - Run Atlantis as a service within your infrastructure (e.g., in Kubernetes, EC2, etc.).
   - Use a managed Atlantis service.

   Configure Atlantis with the following:
   - **GitHub Webhooks**: To trigger Atlantis on pull request events.
      - Navigate to your repository on GitHub.
      - Go to Settings > Webhooks > Add webhook.
      - Set the payload URL to point to your Atlantis server, e.g., http://<your-atlantis-url>/events.
      - Set the content type to application/json.
      - Choose "Let me select individual events" and select Pull Requests and Push events.
      - Save the webhook.
   - **Repository Atlantis YAML Config**: [atlantis.yaml](./atlantis.yaml) defines how Atlantis handles PRs and what Terraform/Terragrunt commands to run.
    - **Server Atlantis Config**: [Documentation](https://www.runatlantis.io/docs/server-side-repo-config) A Server-Side Config file is used for more groups of server config that can't reasonably be expressed by repository Atlantis YAML Config.

2. **Trigger a Deployment**

   When a pull request is created or updated in GitHub to modify the infrastructure code, Atlantis will automatically trigger a `plan` and post the plan output as a comment in the pull request. To approve and deploy the changes:

   - **Run `plan`**:
     In the pull request comment section, use the Atlantis command:
     ```bash
     atlantis plan
     ```

   - **Run `apply`**:
     Once the plan has been reviewed and approved, execute the following command in the PR comment to deploy:
     ```bash
     atlantis apply
     ```

3. **Review the PR**

   - Atlantis will comment the `plan` results on the pull request.
   - If everything looks good, merge the PR to trigger an automatic `apply`.

4. **Automated Plan and Apply on Main Branch**

   Once changes are merged into the `main` (or other deployment branches like `dev` or `prod`), Atlantis will automatically run the `apply` command to deploy the infrastructure changes.

#### Atlantis Commands in Pull Requests
Here are some useful Atlantis commands you can run directly within PR comments:

  - `atlantis plan`: Runs `terraform plan` and posts the output in the PR.
  - `atlantis apply`: Runs `terraform apply` and applies the Terraform changes.
  - `atlantis unlock`: Unlocks a PR locked by an incomplete plan or apply.
  - `atlantis help`: Provides a list of available commands.

#### Tips for Using Atlantis with Terragrunt

- Ensure that each environment (dev, prod, etc.) has its directory structure in the repository (e.g., `infra/dev`, `infra/prod`).
- Configure `autoplan` in `.atlantis.yaml` to automatically run the `plan` when Terraform/Terragrunt files are modified.
- Atlantis locks the state of your infrastructure during the `apply` process to ensure only one deployment happens at a time, preventing conflicts.

## How to Destroying the Cluster (all the deployed infra)
If you need to delete some resources delete the folder that contains terragrunt.hcl and open a Pull Request.

*IMPORTANT: follow the dependency order during deleting the  resources*


## Troubleshooting

If you encounter issues during deployment:

1. Ensure Atlantis server is configured and has sufficient AWS permissions.
2. Ensure the dependency order in the infra.
2. Ensure the S3 bucket that works as a backend is configured correctly.
3. Check that your AWS region, VPC, and subnets are correct.
4. Use `--verbose` to append the Atlantis output logs for details on errors.


## To-do list
- Create a custom AMI image for EKS that is customized and configured with the necessary configurations.
- Create Self hosted runner to be used in the GitHub actions if needed.
- Modules should be moved to another repository to be able to create GitHub tags and be safe to use as 
  a source in the terraform to ensure reliability and ignore any random/unplanned code changes.
- Create a GitHub app to integrate with Atlantis (current setup used my account).
- SSO setup for Atlantis server, right now it is managed by basic authentication.
- expand the functionality of `pre-commit` for better quality.
- Atlantis server should move to run on EKS to handle more amount of hook requests in parallel by set auto-scaling. 
- Atlantis repo config and server config need more adjustment based on the size of the infrastructure.
