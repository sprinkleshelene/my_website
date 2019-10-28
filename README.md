# My Static Website

This repo contains a project for running a website in [AWS](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

## How to use this repo.
If you want to edit the website content - use Index.html to edit (found in HTML folder)

You can run this either locally or using Jenkins.

1. Fork the repository into the Project you are creating the static website for
2. Clone the new repository to your machine
3. Check variables.tf for required inputs
4. Create an .tfvars file in vars/ and add required values based on variables.tf
5. Make sure you have logged into the right account (using console or AWS vault in your terminal)
6. Using credentials, run:
 '''
 - terraform init
 - terraform workspace new "env"
 - terraform plan -var-file vars/"env".tfvars
 '''
7. If you are happy with what will be created, run terraform apply -var-file vars/"env".tfvars

## AWS Services
- Route53
- S3
- Cloudfront

**NOTE**: Certificate was manually created in AWS ACM

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | Specify AWS region | string | `[ "eu-west-1" ]` | yes |
| bucket_name | Specify S3 bucket for static website hosting | string | `"my_bucket"` | yes |
| log_bucket_name | Specify S3 log bucket to send logs to | string | `"log_bucket"` | yes |
| web_certificate_arn | SSL certificate using ACM or other third party domain service | string | `"ARN"` | yes |
| route53_zone_id | Route53 Hosted Zone ID | string | `"ZONE_ID"` | yes |

## Improvements
- Add object lifecycle
- Add redirect to www
- Add RSPEC tests for code validation
- Add alerts
