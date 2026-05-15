# README

Create basic infrastructure to Enacom

## Variables

- **aws_region**: string, required  
  The AWS Region where the infrastructure will be created
- **enterprise_context**: map(string), required  
  A map that contains the enterprise context parameters:

  - **vertical_initials**: string, required  
    The vertical initials, the value restriction is `[ ene | sid | log | sau | ena | sus ]`

  - **vertical**: string, required  
    The Vertical name, the value restriction is `[ Energia | Siderurgia | Logistica | enacom ]`

  - **environment**: strng, required
    The environment name, the value restriction is `[ dev | hml | prd ]`

- **azure_agent**: map(string), required
  A map the contains parameters:

  - **ec2_ami**: string, required  
    The EC2 AMI, naturally is a Amazon Linux 2 AMI. A default value is no possible because Amazon changes the AMI code. The use of aws_ami terraform resource is no possible because it requests EC2 instances recreation every time when Amazon change the AMI code.

  - **pool_name**: string, required  
    The Azure Agent Pool Name

  - **name**: string, default is the `poll_name` value  
    The Azure Agent Name

  - **instance_type**: string, default `t2.medium`  
    The EC2 Instance Type

  - **ebs_volume_size**: integer, default `20`  
    The EBS volume size

- **vpc_cidr_16_suffix**: string, required  
  The VPC CIDR Suffix, by pattern the VPC CIRD size is 16 bits. If you want that the VPC CIDR as `172.25.0.0/16`, you need to value `vpc_cidr_16_suffix` as `72.25.0.0`

## Creating AWS account from scratch

1. Comment the backend configurate

1. Run

   ```bash
   terraform apply -target="module.basic_infrastructure.module.KMSBucketS3"

   terraform apply -target="module.basic_infrastructure.module.S3TerraformState"
   ```

1. Get the kms key with `terraform output` and configure the s3 bucket to terraform state

1. Run `terraform init -migrate-state` and `terraforma apply`.

## Utils

### Recreate EC2 instance

```bash
terraform apply -replace="module.basic_infrastructure.module.EC2AzureDevopsAgent01.aws_instance.this"
```
