resource "aws_s3_bucket" "temp-cloudtrail-access-log-bucket" {
  bucket_prefix = var.logs_bucket_name
  acl           = "log-delivery-write"
  force_destroy = true
}

resource "aws_s3_bucket" "temp-cloudtrail-bucket" {
  bucket_prefix = var.bucket_name
  force_destroy = true

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.temp-cloudtrail-access-log-bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_policy" "temp-cloudtrail-bucket" {
  bucket = aws_s3_bucket.temp-cloudtrail-bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AWSCloudTrailAclCheck20150319",
        "Effect" : "Allow",
        "Principal" : { "Service" : "cloudtrail.amazonaws.com" },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.temp-cloudtrail-bucket.id}"
      },
      {
        "Sid" : "AWSCloudTrailWrite20150319",
        "Effect" : "Allow",
        "Principal" : { "Service" : "cloudtrail.amazonaws.com" },
        "Action" : "s3:PutObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.temp-cloudtrail-bucket.id}/*",
        "Condition" : { "StringEquals" : { "s3:x-amz-acl" : "bucket-owner-full-control" } }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "test_dd" {
  bucket                  = aws_s3_bucket.temp-cloudtrail-bucket.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket_policy.temp-cloudtrail-bucket
  ]
}
