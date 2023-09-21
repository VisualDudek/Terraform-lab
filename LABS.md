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

### Task 11: Disable "aws_instance" but do not delete code
use `count = 0`
**minimort** because aws_instance.amz_linux has "count", its attributes must be accessed on specific instance. 
```hcl
  value       = aws_instance.amz_linux[*].public_ip
                                    # ~~~
```

### Task 12: add aws_instance web_server
add new res. that will utilize images created by Packer
- add locals `tag_key_name` and use it as keymap in tags
NOTE: `${local.tag_key_name}` -> linter will complain, for most time `local.tag_key_name` will be ok BUT for keymap you need parenthesis `(local.tag_key_name) =  `

TIP: for res. that can be multiply always from bgn. think about and use `count.index` 
NOTE: for variable there is no type int -> `number`

- add var `image_version`
- add data "aws_ami" that will filter your Packer image
- add res. "aws_instance" web-server
- add output ip for web-server

---
# Lab - BP training Modules

## Tasks

### Task 1: 
rewrite code from LAB: BP training to standard structure tree: `modules/web-server/*`
- `versions.tf` - terraform block
- `variables.tf`
- `output.tf`
- `main.tf`
those are only recommended filenames, can create nay name, just keep ext. right `.tf`
droped from prev LAB: external script, simple aws instance and related outputs

NOTE: You do not need `.tfvars` BC you want to set vars on root lvl in module block

at the end at root lvl you will have only `main.tf` with provider "aws" and terrafrom block

### Task 2: Run fmt and validate recursive
- `tff -recursive`
- `tfv` will check modules if instlled, no need and no option recursive

### Task 3: use `tflint`
- run tflint with recursiv `tflint --recursive`
- add `required_version` for Terraform in `versions.tf`

### Task 4: import module 
at root lvl. in `main.tf` add module block and set up module vars
- run `tfi` -> will install modules in `.tarrform/modules` check `modules.json`

### Task 5: run terraform-docs for web-server module
- install terraform-docs
- run `terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module`
- check `README.md` file
TIP: view README.md file in "Markdown All in One" VSCode ext.

### Task 6: Terrafrom trace mode for logging
get most verbose log for `tfa`
- `TF_LOG='trace' tfa -auto-approve &> log_trace.txt`
Provider is also a Plugin

NOTE: Terraform using gRPC for communication with Terraform Plugins
**Terraform under the hood**
"Terraform Core" -> calls RPC to "Provider":
- GetProviderSchema RPC
- ValidateProviderConfig RPC
(...)
- ApplyResourceChange RPC

- find in `log_trace.txt` "GetProviderSchema"
NOTE: this is v.good way to check what kind of API was made

NOTE: aws API still respond in XML :)

Terraform is basically a state machine that wraps GO SDK

### Task 7: External module
use external VPC module
check AWS VPC Terrafrom module

- add VPC module
when `source` in module provided without rel. path -> will search in Terraform registry

NOTE: How to apply external module VPC into my custom module? ->
- add in custom module var. for custom VPC
- set vpc_id in (1) security group(!!) (2) set `subnet_id` not vpc_id -> need to add next var
- `subnet_id` should be type `list(string)` BC (check in docs) output is "List of IDs"

- add vars: (1) vpc_id (2) subnet_id in root lvl. main.tf, check desired output in external module outputs
NOTE: in custom vpc for public subnets you need to explicite set `map_public_ip_on_launch`
- set public ip

**Task 7a**: get list of availability_zones
- first simple but get tricky with regions that have AZ > 3 BC you have fixed (3) private and public subnets definition
- ~~returns list with list as first element, not nice and not intuitive -> thoubleshoot running desired blocks~~
NOPE: remove `[*]` bc `.names` will return list of string of all az

NOTE: data "aws_availability_zones" very useful `state` attrib.

**minimort** run only gien Terrform blocks:
`tfp -target=data.aws_availability_zones.available -target=output.list_of_az`

NOTE: check `.terraform/modules/vps/` dir for external VPC src

### 8: Add output
add public ip as output BC outputs from modules are not printed on root lvl

### 9:how to reuse my custom "web_server" block?
if you want run next "web-server" e.g. based on diff distro -> copy module block
**minimort** with two modules will try to create double SG with same name -> ~~tmp solution create SG with diff name~~ NOPE bc based on name_prefix you search for ami -> create prefix for SG

TIP: how to "bool" whole module? -> terrnary operator (Terraform do not have if as first citizen) *module also have count attrib!*
- create var "ubuntu_enable"
- `count` on module has effect e.g. outputs now "web_server" is a List, not single res.

ISSUE: how to print public ip from all modules? do not want to setup new output each time

- use `concat()` fn. to print public ip from both modules -> add "servers_ip" output

- run with number of servers 3 and confirm that all instaces are created in the same az-subnet

### 10: shuffle instances between az
use res. `random_shuffle` inside custom module
- add output for random shuffle result

---
# Lab - BP training Backend
- S3 + DynamoDB, DynamoDB is optional, will enable lock


---
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