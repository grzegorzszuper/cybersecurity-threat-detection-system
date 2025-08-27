resource "aws_s3_bucket_lifecycle_configuration" "buckets" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.raw.id

  rule {
    id     = "expire-raw-logs"
    status = "Enabled"

    filter {               # ← DODAJ TO
      prefix = ""          #    cały bucket
    }

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "processed" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.processed.id

  rule {
    id     = "expire-processed-logs"
    status = "Enabled"

    filter {               # ← DODAJ TO
      prefix = ""
    }

    expiration {
      days = 14
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter {               # ← DODAJ TO
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 14
    }
  }
}
