# Terraform-lab
Terraform labs

`.gitignore` based on gh best practice

## Workspaces
- interpolation seq. -> `${terraform.workspace}`

## devcontainer
based on [python dev container](https://github.com/devcontainers/images/tree/main)

### custom
- VS Code ext.
- features
- mount for AWS credentials and config (setup for local dev)
- VS Code dotfiles fomr repo (awesome)

# examples

## parmeter store
1. If you want to ouput parameter from "aws_ssm_parameter" store you need to flag it as sensitive
2. In order to print (without `<sensitive>`) sensitive output -> `tfo [output name]`

# Terraform docs
[dev Terraform](https://developer.hashicorp.com/terraform)
[Terraform Config. Lang.](https://developer.hashicorp.com/terraform/language)
[Terraform Registry](https://registry.terraform.io/)

[Module Development](https://developer.hashicorp.com/terraform/language/modules/develop)
[Backend S3](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
[Managing Workspaces](https://developer.hashicorp.com/terraform/cli/workspaces)

# Terraform Books
- "Terraform: Up & Running, 3nd ed." 2022
- "Terraform Cookbook" 2023
- "Terraform in Action" 2021
- "Practical GitOps: Infra. management using Terraform, AWS, and GitHub Actions" 2022