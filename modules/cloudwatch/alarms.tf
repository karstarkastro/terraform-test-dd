resource "aws_cloudwatch_log_group" "test_dd" {
  name = var.log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "UnauthorizedAPICalls" {
  name           = "UnauthorizedAPICalls"
  pattern        = "{ ($.errorCode = *UnauthorizedOperation || $.errorCode = AccessDenied* ) }"
  log_group_name = aws_cloudwatch_log_group.test_dd.id

  metric_transformation {
    name      = "UnauthorizedAPICallsEventCount"
    namespace = "CloudTrailMetrics"
    value     = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "UnauthorizedAPICalls" {
  alarm_name          = "CloudTrailUnauthorizedAPICalls"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "UnauthorizedAPICallsEventCount"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_arn]
}

resource "aws_cloudwatch_log_metric_filter" "NoMFAConsoleSignIn" {
  name           = "NoMFAConsoleSignIn"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.additionalEventData.MFAUsed != Yes) }"
  log_group_name = aws_cloudwatch_log_group.test_dd.id

  metric_transformation {
    name      = "NoMFAConsoleSignInEventCount"
    namespace = "CloudTrailMetrics"
    value     = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "NoMFAConsoleSignIn" {
  alarm_name          = "CloudTrailNoMFAConsoleSignIn"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NoMFAConsoleSignInEventCount"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_arn]
}

resource "aws_cloudwatch_log_metric_filter" "RootUsage" {
  name           = "RootUsage"
  pattern        = "{ $.userIdentity.type = Root && $.userIdentity.invokedBy NOT EXISTS && $.eventType != AwsServiceEvent }"
  log_group_name = aws_cloudwatch_log_group.test_dd.id

  metric_transformation {
    name      = "RootUsageEventCount"
    namespace = "CloudTrailMetrics"
    value     = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "RootUsage" {
  alarm_name          = "CloudTrailRootUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RootUsageEventCount"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_actions       = [var.sns_arn]
}



