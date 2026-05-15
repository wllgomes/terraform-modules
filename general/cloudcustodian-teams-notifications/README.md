# Cloud Custodian Teams Notifications

A [Terraform](https://www.terraform.io) module to create [AWS](https://aws.amazon.com/) resources used by Cloud Custodian for send notification to Micro$soft Teams
from WebHook.

<br>
<br>

[![Terraform Version](https://img.shields.io/badge/terraform-1.12.2%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-6.3.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-Douglas%20Farias-blue)](https://www.linkedin.com/in/douglasref/) 
[![Owner](https://img.shields.io/badge/Revised%20by-pH%20Consultoria-blue)](https://www.phconsultoria.com.br)
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.

```bash
module "Sample" {
  source = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudcustodian-teams-notifications/"
  teams_webhook   = ""
}
```
<br>

## References
- https://cloudcustodian.io/docs/aws/resources/aws-common-actions.html#aws-common-actions-notify
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function.html
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2025  [pH Consultoria](https://www.phconsultoria.com.br)
