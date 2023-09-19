# Lab - BP training

## Tasks

### Task 1: Run minimal `main.tf` aws ec2
get AMI ID from:
```sh
aws ssm get-parameters-by-path --path "/aws/service/ami-amazon-linux-latest"
```
choose: `al2023-ami-kernel-6.1-x86_64`

Q: `.terraform` is in `.gitignore` why?
Q: `.terraform.lock.hcl` should be in `.gitignore` or not?
Q: what are `terafform.tfstate` and `terafform.tfstate.backup`?

*There must be a better way* how to get ext. IP from created instance?

### Task 2: Use outputs to get ext. IP info
use `output "NAME" {}` block

### Task 3: Get AMI ID via shell script
use `data "external" "NAME" {}` block and shell script

**minimort** shell script output must be JSON encoded map
*There must be a better way* how to het AMI ID?
-> each hcl **resources** can have (and for aws usually have) **Data Source** that is used in `data` block.

### Task 4: Add default tag to every created resources
use `default_tags` in `provider "aws"` block

**minimort** `default_tag`  is supported in all resources that implement tags, with the exception of the `aws_autoscaling_group` resource.

### Task 5: Get latest Ubuntu AMI ID using Data Source using `aws_ami` data block

**minmort** why cannot filter by `root-device-type`? although `ec2 describe-images --image-ids ami-0989fb15ce71ba39e` shows this field as valid attribute of AMI Image

### Task 6: Add locals and variables
- add local `instance_type` and modify res. "aws_instance"
MINDTHEGAP: `locals` but `local.[name]` without 's' and `variable` -> `var.[name]`
- add variable `name_prefix` -> include this var into instance name
- add variable `distro` with validation "ubuntu" or "amazon" only, use `condition` NOTE: you can include `${var.disto}` into error msg. -> alter instance name

NOTE: do not provide vars in CLI use file `terraform.tfvars` or `terraform.auto.tfvars`
- add `terraform.auto.tfvars` for "BP_training" project

### Task 7: Create res. security group "allow_all"
- create res. `aws_security_group` "allow_all"
- attach security group to instance res.

### Task 8: Use hcl function
- create instance tag with value `timestamp()`

### Task 9: Add terrafrom block
- lock in provider version using "Version Constraints" 
- if you want bump version -> you need to use `-upgrade` flag with `tfi`

`~>` allows only the rightmost version component to increment

**version constrains** [link](https://developer.hashicorp.com/terraform/language/expressions/version-constraints)

### Task 10: Use Packer to build your ami
- in subfolder `build-image` create `vm.pkr.hcl` build with custom `configure-apache.yml` ansible playbook
- add `variables.auto.pkvr.hcl` for variables

# MORT

## not authorized to perfomr this operation
```txt
Error: reading EC2 AMIs: UnauthorizedOperation: You are not authorized to perform this operation.
│       status code: 403, request id: bd422bf0-ba35-4014-b573-c47660bc9803
```
Run terraform in debug mode:
`TF_LOG=debug terraform apply/plan`
will get extend verbosity

# TODO

## pass shell env. into Terraform template:

```hcl
data "external" "shell_env" {
  program = ["bash", "-c", <<-EOT
    echo {
      "my_var": "$MY_ENV_VARIABLE",
      "another_var": "$ANOTHER_ENV_VARIABLE"
    }
  EOT
  ]
}
```

```hcl
resource "example_resource" "example" {
  my_var      = data.external.shell_env.result.my_var
  another_var = data.external.shell_env.result.another_var
  # ... other resource attributes ...
}
```