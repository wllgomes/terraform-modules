[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Service Control Policy (SCP'S)

A [Terraform](https://www.terraform.io) module to apply too many SCP'S in AWS Organizations. You can select
one or more SCP'S to apply in your environment. But, please, read too many times before apply, especially in
production.

**Remember:** SCP apply only DENY effect. 
<br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.6.5%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-5.30.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
<br>


## Getting Started
This is a simple sample. Please read and change as needed.
```bash
module "Sample" {
  source   = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/organizations/scp"
  # S3 Unencrypted Object
  s3_unencrypted_objects = [{
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]

  # All outside regions
  all_outside_region = [{
    region              = "us-east-2"
    exception_principal = ["arn:aws:iam::*:role/[INFRASTRUCTURE_AUTOMATION_ROLE]"]
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]

  # Access-Key Root User
  accesskey_root = [{
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]

  # EBS Default Encrypt
  ebs_default_encrypt = [{
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]

  # Leave/Delete AWS Organizations
  leave_delete_organizations = [{
    exception_principal = ["arn:aws:iam::*:role/[SECURITY_AUTOMATION_ROLE]"]
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]

  # Create, modify or delete Cloudtrail trail
  create_modify_delete_cloudtrail = [{
    exception_principal = ["arn:aws:iam::*:role/[SECURITY_ROLE]"]
    target_id = [
      "ou-id1",
      "ou-id2"
    ]
  }]
}
```


## References
- https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html 
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)


This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2023  [pH Consultoria](https://www.phconsultoria.com.br)
