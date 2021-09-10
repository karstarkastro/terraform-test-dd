provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "eu-west-2"
}

module "s3" {
  source           = "./modules/s3"
  bucket_name      = var.cloudtrail_bucket_name
  logs_bucket_name = var.logs_bucket_name
}

module "sns" {
  source                  = "./modules/sns"
  sns_name                = var.sns_topic_name
  email_for_notifications = var.email_for_cloudwatch_notifications
}

module "iam" {
  source    = "./modules/iam"
  role_name = var.cloudwatch_logs_role
}

module "cloudwatch" {
  source         = "./modules/cloudwatch"
  log_group_name = var.cloudwatch_log_group_name
  sns_arn        = module.sns.sns_arn
}

module "cloudtrail" {
  source        = "./modules/cloudtrail"
  bucket_name   = module.s3.cloudtrail_bucket
  key           = var.kms_key_arn
  log_role_arn  = module.iam.log_role_arn
  log_group_arn = module.cloudwatch.log_group_arn
  depends_on    = [module.s3]
}

module "delete_vpcs" {
  source = "./modules/delete_vpcs"
}
