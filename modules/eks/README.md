<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Cluster access entries<br/>  Example:<br/>  access\_entries = {<br/>    dev = {<br/>      kubernetes\_groups = ["system:masters"]<br/>      principal\_arn     = "arn:aws:iam::123456789012:role/developer-role"<br/>      policy\_associations = {<br/>        read\_only = {<br/>          policy\_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"<br/>          access\_scope = {<br/>            namespaces = ["dev"]<br/>            type       = "namespace"<br/>          }<br/>        }<br/>      }<br/>    }<br/>    admin = {<br/>      kubernetes\_groups = ["system:masters"]<br/>      principal\_arn     = "arn:aws:iam::123456789012:role/admin-role"<br/>      policy\_associations = {<br/>        admin\_access = {<br/>          policy\_arn = "arn:aws:iam::aws:policy/AdministratorAccess"<br/>          access\_scope = {<br/>            namespaces = ["*"]<br/>            type       = "namespace"<br/>          }<br/>        }<br/>      }<br/>    }<br/>  } | <pre>map(object({<br/>    kubernetes_groups = list(string)<br/>    principal_arn     = string<br/>    policy_associations = map(object({<br/>      policy_arn = string<br/>      access_scope = object({<br/>        namespaces = list(string)<br/>        type       = string<br/>      })<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | The authentication mode to use for the cluster. Defaults to IAM. | `string` | `"API_AND_CONFIG_MAP"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | the AWS region | `string` | n/a | yes |
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | the new cluster addons | `map(any)` | <pre>{<br/>  "coredns": true,<br/>  "eks-pod-identity-agent": true,<br/>  "kube-proxy": true,<br/>  "vpc-cni": true<br/>}</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default is public access enabled. | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | the new cluster name | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | the new cluster version | `string` | n/a | yes |
| <a name="input_control_plane_subnet_ids"></a> [control\_plane\_subnet\_ids](#input\_control\_plane\_subnet\_ids) | control\_plane\_subnet\_ids | `list(string)` | `[]` | no |
| <a name="input_create_access_entries"></a> [create\_access\_entries](#input\_create\_access\_entries) | Indicates whether or not the cluster access should be created. | `bool` | `true` | no |
| <a name="input_create_eks_managed_node_groups"></a> [create\_eks\_managed\_node\_groups](#input\_create\_eks\_managed\_node\_groups) | Indicates whether or not the node groups should be created. | `bool` | `true` | no |
| <a name="input_eks_managed_node_groups"></a> [eks\_managed\_node\_groups](#input\_eks\_managed\_node\_groups) | Map of EKS managed node groups examples:<br/>    eks\_managed\_node\_groups = {<br/>        main = {<br/>        ami\_type       = "AL2023\_x86\_64\_STANDARD" # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups<br/>        instance\_types = ["m5.large"]<br/>        min\_size       = 2<br/>        max\_size       = 10<br/>        desired\_size   = 2<br/>        }<br/>    } | <pre>map(object({<br/>    ami_type       = string<br/>    instance_types = list(string)<br/>    min_size       = number<br/>    max_size       = number<br/>    desired_size   = number<br/>  }))</pre> | `{}` | no |
| <a name="input_enable_cluster_creator_admin_permissions"></a> [enable\_cluster\_creator\_admin\_permissions](#input\_enable\_cluster\_creator\_admin\_permissions) | Indicates whether or not the current caller identity should be added as an administrator to the cluster. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | the environment name | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | instance types | `list(string)` | <pre>[<br/>  "m5.xlarge"<br/>]</pre> | no |
| <a name="input_node_security_group_additional_rules"></a> [node\_security\_group\_additional\_rules](#input\_node\_security\_group\_additional\_rules) | Additional rules for the node security group | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_node_security_group_enable_recommended_rules"></a> [node\_security\_group\_enable\_recommended\_rules](#input\_node\_security\_group\_enable\_recommended\_rules) | Indicates whether or not the recommended rules should be added to the node security group. | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | subnet\_ids | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc\_id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | n/a |
| <a name="output_eks_cluster_certificat_authority"></a> [eks\_cluster\_certificat\_authority](#output\_eks\_cluster\_certificat\_authority) | n/a |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
