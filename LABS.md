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

### Task 5: Get latest Ubuntu AMI ID using Data Source using `aws_ami` block

**minmort** why cannot filter by `root-device-type`? although `ec2 describe-images --image-ids ami-0989fb15ce71ba39e` shows this field as valid attribute of AMI Image


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