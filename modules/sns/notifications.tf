resource "aws_sns_topic" "test_dd" {
  name = var.sns_name
}

resource "aws_sns_topic_subscription" "test_dd" {
  topic_arn = aws_sns_topic.test_dd.arn
  protocol  = "email"
  endpoint  = var.email_for_notifications
}
