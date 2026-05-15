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
This module supports both the legacy flat interface and the recommended structured interface that follows the
`aws_cloudfront_distribution` blocks more closely.

### Recommended usage

Use `origin`, `default_cache_behavior` and `response_headers_policy_id` for new distributions:

```hcl
module "Sample" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudfront/cloudfront_external_origin"
  aliases             = ["app.example.com"]
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/example"

  origin = [
    {
      domain_name = "origin.example.com"
      origin_id   = "origin-example"

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  ]

  default_cache_behavior = {
    target_origin_id       = "origin-example"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]

    # Optional: use managed or custom CloudFront policies.
    # When cache_policy_id is set, legacy forwarded_values is not generated.
    cache_policy_id            = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
    origin_request_policy_id   = "216adef6-5c7f-47e4-b989-5492eafa07d3" # Managed-AllViewer
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" # Managed-SecurityHeadersPolicy
  }
}
```

`response_headers_policy_id` can also be provided at the module level. The value inside
`default_cache_behavior.response_headers_policy_id` takes precedence when both are set.

### Legacy usage

Existing consumers can keep using the previous flat variables:

```hcl
module "SampleLegacy" {
  source              = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudfront/cloudfront_external_origin"
  aliases             = ["app.example.com"]
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/example"
  target_origin_id    = "origin.example.com"
  allowed_methods     = ["GET", "HEAD"]
  cached_methods      = ["GET", "HEAD"]
}
```

For backwards compatibility, `target_origin_id`, `allowed_methods` and `cached_methods` are still supported, but
`origin` and `default_cache_behavior` are the recommended arguments for new implementations.


## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)


This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
