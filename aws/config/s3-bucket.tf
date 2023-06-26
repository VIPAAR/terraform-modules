resource "aws_s3_bucket" "config" {
  acl    = "log-delivery-write"
  bucket = "${var.account_name}-config"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      logging,
      server_side_encryption_configuration,
      lifecycle_rule,
    ]
  }
}

resource "aws_s3_bucket_logging" "config" {
  bucket = aws_s3_bucket.config.id

  target_bucket = var.log_bucket
  target_prefix = "s3/${var.account_name}-config/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    id      = "log"
    prefix  = "/"
    status  = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }
}

data "aws_iam_policy_document" "config" {
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
      aws_s3_bucket.config.arn,
      "${aws_s3_bucket.config.arn}/*",
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config.id
  policy = data.aws_iam_policy_document.config.json
}
