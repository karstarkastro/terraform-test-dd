output "cloudtrail_bucket" {
  value = aws_s3_bucket.temp-cloudtrail-bucket.id
}
