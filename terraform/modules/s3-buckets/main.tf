locals {
  common_tags = {
    Project    = var.project
    Env        = var.env
    CostCenter = "Security"
    Owner      = "you"
  }
}

# -------------------------
# Buckets
# -------------------------

# Surowe logi
resource "aws_s3_bucket" "raw" {
  bucket = "${var.project}-${var.env}-raw-logs"
  tags   = local.common_tags
}

# Przetworzone logi (po Lambdzie)
resource "aws_s3_bucket" "processed" {
  bucket = "${var.project}-${var.env}-processed-logs"
  tags   = local.common_tags
}

# Artefakty (np. zip Lambdy, modele)
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project}-${var.env}-artifacts"
  tags   = local.common_tags
}

# Public access block dla każdego bucketa
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

# Wersjonowanie artefaktów
resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# -------------------------
# Lifecycle rules (z wymaganym filter/prefix)
# -------------------------

resource "aws_s3_bucket_lifecycle_configuration" "raw_lifecycle" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.raw.id

  rule {
    id     = "expire-raw-logs"
    status = "Enabled"

    filter { prefix = "" } # całość bucketa

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "processed_lifecycle" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.processed.id

  rule {
    id     = "expire-processed-logs"
    status = "Enabled"

    filter { prefix = "" }

    expiration {
      days = 14
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts_lifecycle" {
  count  = var.lifecycle_rule_enabled ? 1 : 0
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    filter { prefix = "" }

    noncurrent_version_expiration {
      noncurrent_days = 14
    }
  }
}
