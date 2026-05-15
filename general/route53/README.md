[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Route 53

A [Terraform](https://www.terraform.io) module to create [Route53 Zones](https://aws.amazon.com/route53/) and [Route53 Records](https://aws.amazon.com/route53/)
on [Amazon Web Services (AWS)](https://aws.amazon.com/). <br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
* Zones
```bash
module "Sample" {
  source       = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/route53/zones"
  name         = ""
  comment      = ""
  default_tags = {}
  vpc_ids      = [] # Optional (Only for private zones)
}  
```

* Records
```bash
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/route53/records"
  name = ""
  type = ""
  records = []
  zone_id = ""
```


## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record 
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)