resource "aws_sns_topic" "cis_benchmarks" {
  count = length(var.cis_benchmark_alerts) != 0 ? 1 : 0

  name = "cis-benchmarks"
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  count = contains(var.cis_benchmark_alerts, "unauthorized_api_calls") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Unauthorized API Calls"
  pattern        = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied*\")}"

  metric_transformation {
    name      = "UnauthorizedAPICalls"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  count = contains(var.cis_benchmark_alerts, "unauthorized_api_calls") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Unauthorized API Calls"
  alarm_name          = "${var.account_name}-unauthorized-api-calls"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.unauthorized_api_calls[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.unauthorized_api_calls[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "console_signin_without_mfa" {
  count = contains(var.cis_benchmark_alerts, "console_signin_without_mfa") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Console Signin Without MFA"
  pattern        = "{($.eventName=\"ConsoleLogin\") && ($.additionalEventData.MFAUsed !=\"Yes\")}"

  metric_transformation {
    name      = "ConsoleSigninWithoutMFA"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_without_mfa" {
  count = contains(var.cis_benchmark_alerts, "console_signin_without_mfa") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Console Signin Without MFA"
  alarm_name          = "${var.account_name}-console-signin-without-mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.console_signin_without_mfa[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.console_signin_without_mfa[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "root_account_usage" {
  count = contains(var.cis_benchmark_alerts, "root_account_usage") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Root Account Usage"
  pattern        = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"

  metric_transformation {
    name      = "RootAccountUsage"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_account_usage" {
  count = contains(var.cis_benchmark_alerts, "root_account_usage") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Root Account Usage"
  alarm_name          = "${var.account_name}-root-account-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.root_account_usage[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.root_account_usage[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "iam_policy_changes" {
  count = contains(var.cis_benchmark_alerts, "iam_policy_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "IAM Policy Changes"
  pattern        = "{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"

  metric_transformation {
    name      = "IAMPolicyChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_policy_changes" {
  count = contains(var.cis_benchmark_alerts, "iam_policy_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: IAM Policy Changes"
  alarm_name          = "${var.account_name}-iam-policy-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.iam_policy_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.iam_policy_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "cloudtrail_changes" {
  count = contains(var.cis_benchmark_alerts, "cloudtrail_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "CloudTrail Changes"
  pattern        = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"

  metric_transformation {
    name      = "CloudTrailChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_changes" {
  count = contains(var.cis_benchmark_alerts, "cloudtrail_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: CloudTrail Changes"
  alarm_name          = "${var.account_name}-cloudtrail-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.cloudtrail_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.cloudtrail_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "console_authentication_failure" {
  count = contains(var.cis_benchmark_alerts, "console_authentication_failure") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Console Authentication Failure"
  pattern        = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"

  metric_transformation {
    name      = "ConsoleAuthenticationFailure"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_authentication_failure" {
  count = contains(var.cis_benchmark_alerts, "console_authentication_failure") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Console Authentication Failure"
  alarm_name          = "${var.account_name}-console-authentication-failure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.console_authentication_failure[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.console_authentication_failure[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_cmk" {
  count = contains(var.cis_benchmark_alerts, "disable_or_delete_cmk") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Disable Or Delete CMK"
  pattern        = "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"

  metric_transformation {
    name      = "DisableOrDeleteCMK"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "disable_or_delete_cmk" {
  count = contains(var.cis_benchmark_alerts, "disable_or_delete_cmk") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Disable Or Delete CMK"
  alarm_name          = "${var.account_name}-disable-or-delete-cmk"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.disable_or_delete_cmk[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.disable_or_delete_cmk[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "s3_bucket_policy_changes" {
  count = contains(var.cis_benchmark_alerts, "s3_bucket_policy_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "S3 Bucket Policy Changes"
  pattern        = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"

  metric_transformation {
    name      = "S3BucketPolicyChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_policy_changes" {
  count = contains(var.cis_benchmark_alerts, "s3_bucket_policy_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: S3 Bucket Policy Changes"
  alarm_name          = "${var.account_name}-s3-bucket-policy-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.s3_bucket_policy_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.s3_bucket_policy_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "aws_config_changes" {
  count = contains(var.cis_benchmark_alerts, "aws_config_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "AWS Config Changes"
  pattern        = "{($.eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"

  metric_transformation {
    name      = "AWSConfigChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "aws_config_changes" {
  count = contains(var.cis_benchmark_alerts, "aws_config_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: AWS Config Changes"
  alarm_name          = "${var.account_name}-aws-config-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.aws_config_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.aws_config_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "security_group_changes" {
  count = contains(var.cis_benchmark_alerts, "security_group_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Security Group Changes"
  pattern        = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEgress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}"

  metric_transformation {
    name      = "SecurityGroupChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_group_changes" {
  count = contains(var.cis_benchmark_alerts, "security_group_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Security Group Changes"
  alarm_name          = "${var.account_name}-security-group-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.security_group_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.security_group_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "network_acl_changes" {
  count = contains(var.cis_benchmark_alerts, "network_acl_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Network ACL Changes"
  pattern        = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"

  metric_transformation {
    name      = "NetworkACLChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_acl_changes" {
  count = contains(var.cis_benchmark_alerts, "network_acl_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Network ACL Changes"
  alarm_name          = "${var.account_name}-network-acl-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.network_acl_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.network_acl_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "network_gateway_changes" {
  count = contains(var.cis_benchmark_alerts, "network_gateway_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Network Gateway Changes"
  pattern        = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"

  metric_transformation {
    name      = "NetworkGatewayChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "network_gateway_changes" {
  count = contains(var.cis_benchmark_alerts, "network_gateway_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Network Gateway Changes"
  alarm_name          = "${var.account_name}-network-gateway-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.network_gateway_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.network_gateway_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "route_table_changes" {
  count = contains(var.cis_benchmark_alerts, "route_table_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "Route Table Changes"
  pattern        = "{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}"

  metric_transformation {
    name      = "RouteTableChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_changes" {
  count = contains(var.cis_benchmark_alerts, "route_table_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: Route Table Changes"
  alarm_name          = "${var.account_name}-route-table-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.route_table_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.route_table_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "vpc_changes" {
  count = contains(var.cis_benchmark_alerts, "vpc_changes") ? 1 : 0

  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  name           = "VPC Changes"
  pattern        = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"

  metric_transformation {
    name      = "VPCChanges"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_changes" {
  count = contains(var.cis_benchmark_alerts, "vpc_changes") ? 1 : 0

  alarm_actions       = [aws_sns_topic.cis_benchmarks[0].arn]
  alarm_description   = "CIS Benchmark: VPC Changes"
  alarm_name          = "${var.account_name}-vpc-changes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.vpc_changes[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.vpc_changes[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
}
