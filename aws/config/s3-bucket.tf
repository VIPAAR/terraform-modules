resource "aws_s3_bucket" "config" {
  bucket = "${var.account_name}-config"

  lifecycle_rule {
    id      = "log"
    prefix  = "/"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      grant,
      acl,
    ]
  }

  logging {
    target_bucket = var.log_bucket
    target_prefix = "s3/${var.account_name}-config/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "config" {
  depends_on = [
    aws_s3_bucket_public_access_block.config,
    aws_s3_bucket_ownership_controls.config,
  ]

  bucket = aws_s3_bucket.config.id
  acl    = "log-delivery-write"
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
