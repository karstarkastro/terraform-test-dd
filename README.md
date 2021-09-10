# terraform-test-dd
A Terraform test about Account Security Hardening. It performs the following actions:
* Enables CloudTrail
* Ensures CloudTrail logs are stored within a S3 bucket
* Ensures CloudTrail trails are integrated with CloudWatch Logs
* Enables filters and alarms for Cloudwatch that monitor:
    * Unauthorized API calls
    * Mgmt Console sign-in without MFA
    * Usage of the *root* account
* Removes the default VPC in all regions (bash script for this taken from https://github.com/Mattias-/aws-delete-default-vpcs)

## Prerequisites
```
Terraform v1.0.6
aws-cli v2.2.37
Bash
```
Make sure that the  aws-cli has an admin user profile. If not it can be configured by following the steps in
```
aws configure
```
Also confirm that the bash file [delete_default_vpcs.sh](https://github.com/karstarkastro/terraform-test-dd/blob/main/delete_default_vpcs.sh) has execution permission.

Finally, if you desire to:

* Encrypt CloudTrail logs with a CMK key
* Change S3 bucket names
* Personalize the email that will receive notifications from Cloudwatch
* Change the name of various objects as SNS topic name, service role for writing CloudWatch logs, etc.

you can do so by changing the *default* value of the variables specified in [variables.tf](https://github.com/karstarkastro/terraform-test-dd/blob/main/variables.tf)

## Usage
1. Initialize Terraform
```
terraform init
```
2. Next is the plan stage
```
terraform plan -var-file=<your_file_containing_your_aws_access_and_secret_keys.tfvars>
```
3. Followed by the apply stage
```
terraform apply -var-file=<your_file_containing_your_aws_access_and_secret_keys.tfvars>
```
4. Finally if you want to delete the infrastructure you run the destroy command
```
terraform destroy -var-file=<your_file_containing_your_aws_access_and_secret_keys.tfvars>
```
