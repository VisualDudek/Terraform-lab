# Terraform-lab
Terraform labs

`.gitignore` based on gh best practice

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