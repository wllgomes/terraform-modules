[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# Cloudfront (static website with Amazon S3)

A [Terraform](https://www.terraform.io) module to  create a static website using: [Cloudfront Distribution](https://aws.amazon.com/pt/cloudfront/),
[Amazon S3](https://aws.amazon.com/pt/s3/), SSL certificate with  [Amazon ACM](https://aws.amazon.com/pt/acm/) and DNS zone/record in
[Route53](https://aws.amazon.com/pt/route53/). 
<br>
<br>
Attention: All resources must be in the same [AWS Account](https://aws.amazon.com/). <br>
<br>



[![Terraform Version](https://img.shields.io/badge/terraform-1.3.4%20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-4.38.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
<br>


## Getting Started
This is a simple sample, with minimum necessary options. Please read and change as needed.
```bash
module "Sample" {
  source   = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/cloudfront/cloudfront_s3_acm_r53"
  hostname = ""
  domain   = ""
  region   = ""
}
```


## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution 
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#renewal_eligibility 
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration 
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)


This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
