[<img src="https://gitlab.com/uploads/-/system/project/avatar/40750820/logoAZUL_fundoTransparente-pH22.png" width="200"/>](https://www.phconsultoria.com.br)


# RDS

A [Terraform](https://www.terraform.io) module to  [RDS Databases](https://aws.amazon.com/pt/rds/) with [AWS Secret Manager](https://aws.amazon.com/pt/secrets-manager/)
to stored database user password, for Security Compliance, in cloud [Amazon Web Services (AWS)](https://aws.amazon.com/). 
<br>

Root module calls these modules which can also be used separately to create independent resources:
* [db_instance](https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/rds/modules/db_instance) - creates RDS DB instance
* [db_subnet_group](https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/rds/modules/db_subnet_group) - creates RDS DB subnet group
* [db_parameter_group](https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/rds/modules/db_parameter_group) - creates RDS DB parameter group
* [rds_cluster](https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/rds/modules/rds_cluster) - creates RDS cluster
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
  source                 = "git::https://gitlab.com/phconsultoria/phconsultoria-tfm.git//modules/rds"  
  identifier             = ""
  db_subnet_group_name   = ""
  engine                 = ""
  engine_version         = ""
  instance_class         = ""
  vpc_security_group_ids = []
  allocated_storage      = ""
  max_allocated_storage  = ""
  availability_zones     = []
}
```
<br>

## References
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
- https://docs.aws.amazon.com/pt_br/AmazonRDS/latest/UserGuide/USER_WorkingWithParamGroups.html 
<br>

## License

[![License](https://img.shields.io/badge/License-Apache2.0-blue)](https://www.apache.org/licenses/LICENSE-2.0)

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](LICENSE) for full details.

Copyright &copy; 2022  [pH Consultoria](https://www.phconsultoria.com.br)
