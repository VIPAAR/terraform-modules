resource "aws_s3_bucket" "remote_state_backend" {
  bucket = "${var.name_prefix}-remote-state-backend"
  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      logging,
    ]
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.remote_state_backend.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_logging" "remote_state_backend" {
  bucket = aws_s3_bucket.remote_state_backend.id

  target_bucket = var.log_bucket_id
  target_prefix = "s3/${var.name_prefix}-remote-state-backend/"
}

module "remote_state_backend_bucket_policy" {
  bucket_arn   = aws_s3_bucket.remote_state_backend.arn
  kms_key_arns = [aws_kms_key.remote_state_backend.arn]
  source       = "../secure-bucket-policy"
}

resource "aws_s3_bucket_policy" "remote_state_backend" {
  bucket = aws_s3_bucket.remote_state_backend.id
  policy = module.remote_state_backend_bucket_policy.json
}
