resource "aws_cloudtrail" "test_dd" {
  name                          = "temp-cloudtrail"
  s3_bucket_name                = var.bucket_name
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  include_global_service_events = true
  kms_key_id                    = var.key
  cloud_watch_logs_role_arn     = var.log_role_arn
  cloud_watch_logs_group_arn    = "${var.log_group_arn}:*"
  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}
