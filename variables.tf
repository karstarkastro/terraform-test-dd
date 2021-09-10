variable "aws_access_key" {
  description = "Access key for access to AWS"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Secret key for access to AWS"
  type        = string
  sensitive   = true
}

variable "kms_key_arn" {
  description = "KMS Key ARN to encrypt CloudTrail logs"
  type        = string
  # change the following line to specify the ARN of the key used for encryption
  default = ""
}

variable "cloudtrail_bucket_name" {
  description = "S3 bucket name used for storing CloudTrail logs"
  type        = string
  # change the following line to give an unique prefix name to the S3 bucket
  default = "temp-cloudtrail-logs-bucket"
}

variable "logs_bucket_name" {
  description = "S3 bucket name used for storing access logs to the bucket for CloudTrail logs"
  type        = string
  # change the following line to give an unique prefix name to the S3 bucket
  default = "temp-bucket-access-logs"
}

variable "cloudwatch_log_group_name" {
  description = "Name of the group in Cloudwatch Logs where all the CloudTrail logs will be sent"
  type        = string
  # change the following line to give an unique name to the group name
  default = "aws-cloudwatch-logs"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for CloudTrail alarms"
  type        = string
  # change the following line to give a name to the SNS topic
  default = "cloudtrail-alarms-topic"
}

variable "email_for_cloudwatch_notifications" {
  description = "Email used to receive notifications from CloudWatch"
  type        = string
  # change the following line to specify the receiving email address
  default = "abc@notarealemail.com"
}

variable "cloudwatch_logs_role" {
  description = "Name for the IAM role that will write logs to CloudWatch"
  type        = string
  # change the following line to specify another name for the role
  default = "api-gateway-cloudwatch-role"
}

