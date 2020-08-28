# Luminor assessment overview

This is a technical guide to provision EKS cluster in was using terraform and deploy Atlantis application on top of EKS to automating Terraform via pull requests.

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

3- Download the credentials.csv file which contains the new user credentials.

4- Add AWS credentials in your local machine:

   - Setup AWS credential for Windows or Mac from [here](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html).   

  - Setup AWS credential for Linux:  ```mkdir -p ~/.aws/ && touch ~/.aws/credentials``` with the below syntax and add the **Access key ID** and **Secret access key**.
```bash
[default]
region = us-east-1
aws_access_key_id = AKI******************NU
aws_secret_access_key = FC*******************q27v

```
## Step-2 Terraform:

### 2.a Install:

- Download Terraform `>= 0.12` [here](https://releases.hashicorp.com/terraform/) and follow the guide [here](https://www.terraform.io/intro/getting-started/install.html) on how to install Terraform on your specific system.
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
                "AWS": "arn:aws:iam::<Account_ID>:user/<your_AWS_User_name>"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::<BUCKET_NAME>"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:I am::<Account_ID>:user/<your_AWS_User_name>"
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

- Edit values based on your project in `terraform.vars` file-based on your project.

- RUN `terraform init` **to download and initialize the appropriate provider plugins.**
- RUN `terraform plan` **to see what Terraform will do before we decide to apply it.**
- RUN `terraform apply -var-file terraform.tfvars` **This command will provision the eks cluster.**
- **Wait** till the end of provisioning, you will get a completion message and outputs for Example:

 ```
Apply complete! Resources: 16 added, 0 changed, 0 destroyed.
Outputs:

eks_cluster_certificat_authority = [
  {
    "data" = "LS0tLS********1CR********UdJTiBDRV*************VSVE********lGSUNB********VEUtLS0tLQo="
  },
]
eks_cluster_endpoint = https://99*****2F6**0**6A8.gr7.us-east-1.eks.amazonaws.com
  ```
## Step-3 Connect to EKS cluster
- Install `kubectl` in local machine based on your OS [here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

- RUN `export KUBECONFIG=~/.kube/config` **to set the kubernetes configuration in PATH.**
- RUN `aws eks update-kubeconfig --region "region" --name "CLUSTER-NAME"`**this command will generate a config file under ~/.kube directory with all configuration required.**
- RUN `kubectl cluster-info`
     *to get cluster details and check your configuration.*


## Step-3 Setup Atlantis: [official documentations](https://www.runatlantis.io/docs/)

### 3.a prerequisites:
  - get terraform version `terraform --version`
  -  install and configure helm:
```bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > /tmp/get_helm.sh
chmod 700 /tmp/get_helm.sh
./tmp/get_helm.sh
kubectl apply -f helm/rbac.yaml
helm init --service-account tiller
kubectl --namespace kube-system get pods | grep tiller

```
- Create a Personal Access [Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/#creating-a-token) with **repo** scope.
- Generate Webhook secret via Ruby with `ruby -rsecurerandom -e 'puts SecureRandom.hex(32)'` or [online](https://www.browserling.com/tools/random-string)


**3.b Using helm to deploy Atlantis on kubernetes cluster:**

1- Atlantis has an [official Helm chart](https://hub.kubeapps.com/charts/stable/atlantis).

2- Generate a `values.yaml` file by running: `helm inspect values stable/atlantis > helm/values.yaml`

3- Add the following values in helm/values.yaml:

```yaml
#  add Atlassian public domain for :
atlantisUrl: http://atlantis.example.com 

# Add your terraform repository:
##in my case I'm using the same repository
orgWhitelist: github.com/ahmedbadawy4/Luminor-task 

# If using GitHub, specify like the following: 
github:
  user: <GitHub_Username>
  token: <Github_token>
  secret: <Webhook_secret>

#Specify AWS credentials to be mapped to ~/.aws inside the atlantis container
# to allow atlantis container access AWS:
aws:
   credentials: |
              [default]
              aws_access_key_id = B4**********NU
              aws_secret_access_key = /tY6*********************oq27v
              region = <region>
   config: |
     [profile a_role_to_assume]
     role_arn = arn:aws:iam::451098466741:role/Allows_EKS_access
     source_profile = default
#defaultTFVersion set the default terraform version to be used in atlantis server
## it should be the same as your terraform version to overcome any terraform lock status
defaultTFVersion: 0.12.26

``` 
> More cusumization value in the official documentation [here](https://github.com/helm/charts/tree/master/stable/atlantis#customization)


4- deploy Atlantis using helm:

- create atlantis namespace `kubectl create ns atlantis`

- Run helm `helm install -f helm/values.yaml --name atlantis stable/atlantis --namespace atlantis`

- ***NOT RECOMMENDED*** In my case i'll use nodePort to access the atlantis:
  
  RUN `kubectl get svc` to list all service and get atlantis `nodePort`.
  
**3.c Configuring Webhooks** Official documentation [here](https://www.runatlantis.io/docs/configuring-webhooks.html#github-github-enterprise)
- navigate to the repository home page and click `Settings`. 
- Select `Webhooks` or Hooks in the sidebar and click `Add webhook`
- Set Payload URL to http://$URL/events (or https://$URL/events if you're using SSL) where $URL is where Atlantis is hosted.
  > in my case `$URL = http://ec2_public_IP:nodePort` 
- set Content-type to application/json
- set Secret to the Webhook Secret you generated previously
  > NOTE If you're adding a webhook to multiple repositories, each repository will need to use the same secret.
- select Let me select individual events
- check the boxes:
  - Pull request reviews
  - Pushes
  - Issue comments
  - Pull requests
- leave Active checked
- Click Add webhook

## Get Started [here](https://www.runatlantis.io/guide/#getting-started)

## add changes in any branch and open a PUll request then add a comment:
`atlantis plan -d .` and Atlantis will comment back the planned output of the terraform code changed 

After approving the plan RUN `atlantis apply -d . ` to apply changes then you Merge the code 
![Github PR](/images/atlantis_Github_screenshoot.png)

- visit Atlantis URL `http://ec2_ip:nodePort` you will get the lock of this PR:
![Atlantis interface](/images/atlantis_lock_screenshoot.png)
## To-Do-List:
1- setup an Atlantis domain with SSL and configure it to overcome disconnection in case nodePort changed for any reason.

2- Use the official terraform EKS module to get more variety and more customization.

3- Configured Multiple IAM roles with different levels of permissions (depend on each team's requirements).

4- protect aster branch "Protected branches are available to Pro, Team, and Enterprise users"
