resource "aws_s3_bucket" "origin" {
  bucket = local.bucket_name
  dynamic "cors_rule" {
    for_each = var.origin_bucket_cors
    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      logging,
      server_side_encryption_configuration,
    ]
  }
  tags = local.tags
}

resource "aws_s3_bucket_logging" "origin" {
  bucket = aws_s3_bucket.origin.id

  target_bucket = data.aws_s3_bucket.log_bucket.id
  target_prefix = "s3/${var.distribution_name}/"
}

resource "aws_s3_bucket_versioning" "origin" {
  bucket = aws_s3_bucket.origin.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "origin" {
  bucket = aws_s3_bucket.origin.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "origin_bucket_policy" {
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
      aws_s3_bucket.origin.arn,
      "${aws_s3_bucket.origin.arn}/*",
    ]
    sid = "DenyUnsecuredTransport"
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    principals {
      identifiers = [
        aws_cloudfront_origin_access_identity.origin.iam_arn,
      ]
      type = "AWS"
    }
    resources = [
      aws_s3_bucket.origin.arn,
      "${aws_s3_bucket.origin.arn}/*",
    ]
    sid = "AllowCloudFront"
  }
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = aws_s3_bucket.origin.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}

