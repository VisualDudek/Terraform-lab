spotkanie 2/3

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
