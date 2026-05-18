[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# AWS Terraform Modules

A [Terraform](https://www.terraform.io) modules for [Amazon Web Services (AWS)](https://aws.amazon.com/) services. <br>
<br>


[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting started
For usage the "terraform modules" stored here, follow this **sample** below:

```
module "Sample" {
  source = "git::https://github.com/wllgomes/terraform-modules.git//general/MODULE-NAME-HERE?ref=main"
  [options module]
}
```
The **MODULE-NAME-HERE** must be changed according your needs. <br>
<br>

## About pH Consultoria
Founded in 2015 and based in Belo Horizonte/Brazil, the pH Consultoria is specialized in AWS cloud environments, 
focused in Infrastructure, Security and Automations. We offer commercial support for all of our projects and encourage 
you to reach out if you have any questions or need help. Feel free to email us at 
contato@phconsultoria.com.br.<br>

We can also help you with:
* Consulting & training on AWS.
  * Security
  * Infrastructure
  * Automations (Infra as a Code, Configuration Management)
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)