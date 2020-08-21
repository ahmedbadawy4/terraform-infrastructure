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

## Step-2 Install Terraform:

- Download Terraform 0.12 [here](https://releases.hashicorp.com/terraform/) and follow the guide [here](https://www.terraform.io/intro/getting-started/install.html) on how to install Terraform on your specific system.
- Check terraform installation Run: `terraform version`

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