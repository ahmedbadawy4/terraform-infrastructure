# Luminor assessment overview

This is a technical guide to provision EKS cluster in was using terraform and deploy atlantis application on top of eks to automating Terraform via pull requests.

## 📝 Table of Contents:

- [Prerequisites](#Prerequisites)
- [Setup AWS credentials](#new_environment)
- [Install Terraform](#Install_Terraform)
- [Provision EKS](#provesion_EKS)
- [Deploy Atlantis](#Deploy_Atlantis)


## Prerequisites
- AWS account [Signup/Login](https://console.aws.amazon.com/console/home?nc2=h_ct&src=header-signin)


## Step-1 Setup AWS credentials (Linux OS):

1- Create a new user in the IAM Section on AWS [here](https://console.aws.amazon.com/iam/home?region=us-east-1#/users) and select "*Programmatic access*".

2- Either Attached the AdministratorAccess policy or add the new user to the admin group or add specific policies one by one.  

3- Download the credentials.csv file which contain te new user credentials.

4- Add AWS credentials in your local machine:
   
  - Create credential file ```mkdir -p ~/.aws/ && touch ~/.aws/credentials``` with the below syntax and add the **Access key ID** and **Secret access key**.
```bash
[default]
region = us-east-1
aws_access_key_id = AKI******************NU
aws_secret_access_key = FC*******************q27v

```
**- note:** 
  Setup AWS credential for Windows or mac from [here](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html).

## Step-2 Terraform:

### 2.a Install:

- Download Terraform 0.12 [here](https://releases.hashicorp.com/terraform/) and follow the guide [here](https://www.terraform.io/intro/getting-started/install.html) on how to install Terraform on your specific system.
- Check terraform installation Run: `terraform version`

### 2.b initial configurations:

- Setup S3 bucket as a backend to terraform.tfstate file:
*DON'T* make sure that the S3 bucket is not public!
*Setup S3 permission:*        Navigate to Permission > Bucker Policy  and add the below policy:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::451098466741:user/<your_AWS_User_name>"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::<BUCKET_NAME>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::451098466741:user/<your_AWS_User_name>"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::<BUCKET_NAME>/*"
        }
    ]
}
```
- Add `S3 bucket name` and `path to terraform.tfstate` in `backend.tf` file:

```
terraform {
  backend "s3" {
    bucket = "<Bucket_NAME>"
    key    = "PATH/TO/terraform.tfstate"
    region = "<BUCKEt_REGION>"
  }
}
```

- Edit values based in your project in `terraform.vars` file:
```tf
NAME="eks-cluster"
#"Cluster name"
min_size="1"
#"Minimum number of worker nodes"
max_size="2"
#"Maximum number of worker nodes"
VPC_CIDR="10.0.0.0/16"
#"first availability zone"
AZ_1="us-east-1a"

# "subnet for the first Availability Zone"
SUBNET_1_CIDR="10.0.1.0/24"

#"second availability zone"
AZ_2="us-east-1b"

#"subnet for the second Availability Zone"
SUBNET_2_CIDR="10.0.2.0/24"
```
- RUN `terraform init`

  > *This command will download and initialize the appropriate provider plugins.*
- RUN `terraform plan` 

  >   *This command will let us see what Terraform will do before we decide to apply it.*
- RUN `terraform apply -var-file terraform.tfvars` 

  >  *This command will provision the eks cluster.*
- Wait till the end of provisioning, you will get a completion message and outputs for Example:

 ```
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
Outputs:

eks_cluster_certificat_authority = [
  {
    "data" = "LS0tLS1CRUdJTiBDRV*************VSVElGSUNBVEUtLS0tLQo="
  },
]
eks_cluster_endpoint = https://99*****2F606A8.gr7.us-east-1.eks.amazonaws.com
  ```
## Step-3 Connect to cluster
- Install `kubectl` in local machine based on your OS [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- RUN `export KUBECONFIG=~/.kube/config`
     *to set the kubernetes configuration in PATH.*
- RUN `aws eks update-kubeconfig --name "CLUSTER-NAME"`
     *this command will generate a config file under ~/.kube directory with all configuration required.*
- RUN `kubectl cluster-info`
     *to get cluster details and check your configuration.*


## Step-3 Deploy Atlantis:

  **Using helm deploy Atlantis on kubernetes cluster:**

1- Atlantis has an [official Helm chart](https://hub.kubeapps.com/charts/stable/atlantis).

2- Create a `values.yaml` file by running:

```sh
helm inspect values stable/atlantis > values.yaml
```
3- Edit `values.yaml` and add your access credentials and webhook secret
```yaml
# for example
github:
  user: foo
  token: bar
  secret: baz
``` 
4- Set your orgWhitelist (see Repo Whitelist for more information)

5- More customization is [here](https://github.com/helm/charts/tree/master/stable/atlantis#customization).

 
## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)