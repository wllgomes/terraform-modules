[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# IAM Identity Center

A [Terraform](https://www.terraform.io) modules to create and manage [IAM Identity Center](https://aws.amazon.com/pt/iam/identity-center/) resources with
[Permission Sets](https://aws.amazon.com/sso/), [Users](https://aws.amazon.com/pt/iam/identity-center/) and [Groups](https://aws.amazon.com/pt/iam/identity-center/) 
in [Amazon Web Services (AWS)](https://aws.amazon.com/). <br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.

* Permission Set
```bash
locals {
  all_accounts = tolist(toset(values(local.accounts)))
  accounts = {
    account01 = "123456789123"
  }
} # Sample - You can change this

module "Sample" {
  source                 = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/identity_center/permission_sets"
  name                   = "" # Required 
  description            = "" # Required
  session_duration_hours = "" # Required
  default_tags           = {} # Required
  managed_policies_arn   = "" # Required
  group_assignments      = {
    (data.aws_identitystore_group.id) = local.all_accounts # This data must be created in advance
  }
}
```
* Users
```bash
module "Sample" {
  source       = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/sso/modules/identity_center/users"
  display_name = "" # Required
  first_name   = "" # Required
  last_name    = "" # Required
  email        = "" # Required
}
``` 
* Groups
 ```bash
module "Sample" {
  source       = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/sso/modules/identity_center/groups"
  display_name = "" # Required
  description  = "" # Required
  members      = "" # Required
}
```

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user 
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)