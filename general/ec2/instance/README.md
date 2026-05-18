[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# ec2_instance

A [Terraform](https://www.terraform.io) module to create [Amazon EC2 Instance](https://aws.amazon.com/ec2/) 
encrypted with [Amazon KMS ](https://aws.amazon.com/kms/) on [Amazon Web Services (AWS)](https://aws.amazon.com/). <br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
```bash
module "SampleEC2" {
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/ec2/instance"
  ec2_name           = ""
  ami                = ""
  ec2_type           = ""
  security_group_ids = []
  subnet_id          = ""
  volume_size        = ""
}
```
<br>

### Customizing metadata_options
The `metadata_options` block is optional. When omitted, the module uses secure defaults
(`http_endpoint = "enabled"`, `http_tokens = "required"`, `http_put_response_hop_limit = 1`,
`instance_metadata_tags = "enabled"`). Any subset of fields can be overridden:
```bash
module "SampleEC2" {
  source             = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/ec2/instance"
  ec2_name           = ""
  ami                = ""
  instance_type      = ""
  security_group_ids = []
  subnet_id          = ""
  volume_size        = 30

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }
}
```
<br>

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
