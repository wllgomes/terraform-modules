# ACM (AWS Certificate Manager)

A [Terraform](https://www.terraform.io) module to create TLS Certificate with [AWS Certificate Manager](https://aws.amazon.com/acm/).
This module has setting for only "DNS validation method" with domain zones/records in [Route 53 Services](https://aws.amazon.com/route53/) in [Amazon Web Services (AWS)](https://aws.amazon.com/).
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
  source      = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/acm"
  domain_name = ""
  zone_id     = ""
}
```
<br>

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate 
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
