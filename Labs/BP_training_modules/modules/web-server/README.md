<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web-server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.server_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_distro"></a> [distro](#input\_distro) | n/a | `string` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix added for name of every resource | `string` | `"awsninja12"` | no |
| <a name="input_number_of_servers"></a> [number\_of\_servers](#input\_number\_of\_servers) | Number of instances to create | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_server-server_ip"></a> [web\_server-server\_ip](#output\_web\_server-server\_ip) | Public IP of created WEB server |
<!-- END_TF_DOCS -->