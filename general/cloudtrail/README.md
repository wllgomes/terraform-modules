# Cloudtrail

A [Terraform](https://www.terraform.io) module to create [AWS Cloudtrail](https://aws.amazon.com/cloudtrail/) in [Amazon Web Services (AWS)](https://aws.amazon.com/)
without event_selector.
<br>
<br>

[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.

```bash
module "Sample" {
  source         = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudtrail"
  name           = ""
  s3_bucket_name = ""
}
```
<br>

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
