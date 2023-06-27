resource "aws_s3_bucket" "log" {
  bucket = "${var.name_prefix}-log"
  acl    = "log-delivery-write"
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      server_side_encryption_configuration,
      lifecycle_rule,
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    id     = "log"
    status = "Enabled"

    filter {
      prefix  = "/"
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log" {
  bucket = aws_s3_bucket.log.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "log" {
  statement {
    actions = [
      "s3:PutObject",
    ]
    principals {
      identifiers = [
        data.aws_elb_service_account.main.arn,
      ]
      type = "AWS"
    }
    resources = [
      "${aws_s3_bucket.log.arn}/elb/*",
    ]
    sid = "EnableELBLogging"
  }

  statement {
    actions = [
      "s3:*",
    ]
    condition {
      test = "Bool"
      values = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type = "AWS"
    }
    resources = [
      aws_s3_bucket.log.arn,
      "${aws_s3_bucket.log.arn}/*",
    ]
    sid = "DenyUnsecuredTransport"
  }

  statement {
    actions = [
      "s3:PutObject",
    ]
    condition {
      test = "StringEquals"
      values = [
        "bucket-owner-full-control",
      ]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.log.arn}/elb/*",
    ]
    sid = "AWSLogDeliveryWrite"
  }

  statement {
    actions = [
      "s3:GetBucketAcl",
    ]
    principals {
      identifiers = [
        "delivery.logs.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      aws_s3_bucket.log.arn,
    ]
    sid = "AWSLogDeliveryAclCheck"
  }
}

resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id
  policy = data.aws_iam_policy_document.log.json
}
