[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Virtual Private Network (VPN Site-to-Site)

A [Terraform](https://www.terraform.io) module to apply a Virtual Private Network (VPN) "Site-to-Site | IPSec" between AWS and your external place. Please, read too many times before apply, especially in
production.
<br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.7.3%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-5.30.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
<br>


## Getting Started
This is a simple sample. Please read and change as needed.
```bash
module "VPNIPSec" {
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/vpc/vpn"

  aws_vpn_gateway = [{
    vpc_id = "VPC ID"
  }]
  aws_customer_gateway = [{
      device_name = "cgw-sample"
      ip_address  = "IP Address on-premises environment"
    }]
  aws_vpn_connection = [{}]
  aws_vpn_connection_route = [{
      destination_cidr_block = "192.168.1.0/24"
      vpn_connection_id      = aws_vpn_connection.this.id
    }]
}
```


## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_attachment
- https://docs.aws.amazon.com/pt_br/vpn/latest/s2svpn/VPC_VPN.html
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)


This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2024  [pH Consultoria](https://www.phconsultoria.com.br)
