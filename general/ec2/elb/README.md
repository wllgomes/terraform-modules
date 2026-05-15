[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Elastic Load Balancer (ELB)

A [Terraform](https://www.terraform.io) module to  [Elastic Load Balancer](https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/userguide/what-is-load-balancing.html) on [Amazon Web Services (AWS)](https://aws.amazon.com/). <br>
<br>

[![Terraform Version](https://img.shields.io/badge/terraform-1.5.7%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-5.19.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Owner](https://img.shields.io/badge/Developed%20by-https://www.phconsultoria.com.br-blue)](https://www.phconsultoria.com.br)<br>
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
```bash
module "Sample_ALB" {
  source      = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/ec2/elb"  
  lb = [{
    name            = "sample_elb"
    security_groups = ["security_group_id"]
    subnets         = ["subnet_id"]
    tags = merge(
      var.default_tags,
      {
        Name = "sample-elb"
      }
    )
  }]
  target_groups = [{
    name             = "sample-tg"
    port             = "80"
    protocol         = "http"
    protocol_version = "http2"
    vpc_id           = "vpc_id"
    tags = merge(
      var.default_tags,
      {
        Name = "sample-tg"
      }
    )
    health_check = {
      port = "80"
    }
  }]
  targets = [{
    target_id = "i-12303c51926be9999"
    port = "80"
  }]
  listener = [
    {
      port     = "80"
      protocol = "HTTP"
      default_action = {
        type = "redirect"
        redirect = {
          port        = "443"
          protocol    = "HTTPS"
          status_code = "HTTP_301"
        }
      }
    },
    {
      port            = "443"
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate.xyz.arn
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
      default_action = {
        type = "forward"
      }
    }
  ]
}
```
<br>

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener 
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2023  [pH Consultoria](https://www.phconsultoria.com.br)
