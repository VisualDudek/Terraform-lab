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

### Task 2: USe outputs to get ext. IP info
use `output "NAME" {}` block