locals {
  common_tags = {
    Project    = var.project
    Env        = var.env
    CostCenter = "Security"
    Owner      = "you"
  }
}

# Bucket na surowe logi
resource "aws_s3_bucket" "raw" {
  bucket = "${var.project}-${var.env}-raw-logs"
  tags   = local.common_tags
}

# Bucket na przetworzone logi (po Lambdzie)
resource "aws_s3_bucket" "processed" {
  bucket = "${var.project}-${var.env}-processed-logs"
  tags   = local.common_tags
}

# Bucket na artefakty (zip Lambdy, modele SM itd.)
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.env}-artifacts"
  tags   = local.common_tags
}

# Blokada publicznego dostępu (bezpieczeństwo)
resource "aws_s3_bucket_public_access_block" "raw" {
  bucket                  = aws_s3_bucket.raw.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "processed" {
  bucket                  = aws_s3_bucket.processed.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket                  = aws_s3_bucket.artifacts.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Wersjonowanie artefaktów (przydaje się na zip/model)
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle: szybkie czyszczenie, żeby nie generować kosztów
resource "aws_s3_bucket_lifecycle_configuration" "buckets" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.raw.id

  rule {
    id     = "expire-raw-logs"
    status = "Enabled"
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
    noncurrent_version_expiration {
      noncurrent_days = 14
    }
  }
}
