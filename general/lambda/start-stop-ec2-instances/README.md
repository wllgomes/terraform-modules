[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Lambda Function (Start/Stop EC2 instances)

A [Terraform](https://www.terraform.io) module to create [Lambda Function](https://aws.amazon.com/lambda/) for schedule Start/Stop in
[Amazon EC2 Instances](https://aws.amazon.com/ec2/) on [Amazon Web Services (AWS)](https://aws.amazon.com/). <br>
<br>
Notes:
* The "Default tag" used to Start/Stop instances is: ```AutoOff = True``` for shutdown instances and ```AutoOn = True``` for startup instances. You must set this in your EC2 instances. 
* You can create a new IAM Role with a new policy, or set existing IAM Role ARN. 


[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
```bash
module "Sample" {
  source           = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/lambda/start-stop-ec2-instances"
  name             = ""
  schedule_action  = ""
  schedule         = "" # Example: cron(0 22 ? * MON-FRI *)
} 
```
<br>

## References
- https://aws.amazon.com/premiumsupport/knowledge-center/start-stop-lambda-eventbridge
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
- https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html 
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)