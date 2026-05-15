[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Cloudfront (external origin)

A [Terraform](https://www.terraform.io) module to  create [Cloudfront Distribution](https://aws.amazon.com/pt/cloudfront/) with
[AWS Certificate Manager](https://aws.amazon.com/acm/) and external origin (Outside AWS how Webserver, for example).
<br>
<br>



[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
```bash
module "Sample" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudfront/cloudfront_external_origin"
  domain_name         = []
  target_origin_id    = ""
  allowed_methods     = []
  cached_methods      = []
  acm_certificate_arn = ""
}
```


## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)


This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
