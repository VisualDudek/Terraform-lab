spotkanie 2/3 AND 3/3

# 2/3

### `variable` block
zmienne block `variable`
`locals` with `s` but `variable` without `s`

TODO: snipety do terraforma do VSCode

shell env
TF_VAR_name_prefix=[value] tfa

file `terraform.tfvars` or `terraform.auto.tfvars`
?`auto.tfvars` have the highest priority?

TF_VAR_name_prefix=[value] tfa -var "name_prefix=kot"

there is also `-var-file` flag

`sensitive = true` brak widocznych znaków also no data in Terraform logs and outputs `(sensitive value)`

### terafform console
!!! `tfc`
```
> aws_instance.app_server
```
will return JSON with all attributes

NOTE: HCL User Function Extension

### lock version of providers e.g. `aws`
To bump version locked in `.terraform.lock.hcl` use `-upgrade` flag

`terraform` block

**version constrains** [link](https://developer.hashicorp.com/terraform/language/expressions/version-constraints)

NOTE: if you already have locked aws provider version you need to `tfi -upgrade`
locked versions are stored in `.terraform.lock.hcl` file

**minimort:** chcnge version to `< 4.0` and try `tfa`

`~>` allows only the rightmost version compnent ot increment

tfenv for switching teraform versions (old project)

### packer
packer + ansible-playbook inside `build-image` dir
add `variables.auto.pkrvars.hcl` bc you do not want to type each time `packer buld . -var="STRING"` 

WARNING: for OpenSSH >= 9.0 you must add an additional option to enable `scp`
```toml
#~/.ansible.cfg
[ssh_connection]
scp_extra_args = "-O"
```

### Ansible
Ansible `apt` utilize `aptitiute` -> force using apt `force_apt_get: ture` which is by default `false`.

### block `data`
used block data for created ami in packer

### Terraform autovars
cannot have ending `.hcl` as Packer
only `.tfvars`

### Terraform state
content of `terraform.tfstate` file
all atributes from data block -> "aws_ami" 
many interesting infomrations

### Terraform priject/module idiomatic strucutre
how to structure your Terraform projects?

# 3/3
!!!Prezentacja

terraform-docs -> check on gh

`terrafrom fmt -recursive` recursive flag

`tflint` also with `--recursive` flag

`TF_LOG="trace"` the most verbose log

link do artykułu Jakuba

## terraform-docs

## tflint

## Modules
can add modules from git or terrafrom registry

need to `tfi` again, check `.terraform` dir and `modules` sub-dir

### Terraform registry modules

- AWS VPC Terraform module

output modulu nie printuje sie na projekcie, need to create output on main and provide output from module

- can copy module and rename "amz_web_server" -> quick reusable
- `count` as zero -> meta if 

- on output use `concat`

!!! check .terraform/modules/vps

## Backends
S3 + DynamoDB

## Workspaces
