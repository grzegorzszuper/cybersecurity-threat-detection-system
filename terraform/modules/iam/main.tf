locals {
  common_tags = {
    Project    = var.project
    Env        = var.env
    CostCenter = "Security"
    Owner      = "you"
  }
}

# -------- Lambda role --------
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project}-${var.env}-lambda-preprocess-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# CloudWatch Logs permissions
resource "aws_iam_policy" "lambda_logs" {
  name   = "${var.project}-${var.env}-lambda-logs"
  policy = data.aws_iam_policy_document.lambda_logs.json
  tags   = local.common_tags
}

data "aws_iam_policy_document" "lambda_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

# S3 access: read raw, write processed, read/write artifacts (np. zip)
resource "aws_iam_policy" "lambda_s3" {
  name   = "${var.project}-${var.env}-lambda-s3"
  policy = data.aws_iam_policy_document.lambda_s3.json
  tags   = local.common_tags
}

data "aws_iam_policy_document" "lambda_s3" {
  statement {
    sid     = "ReadRaw"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.raw_bucket_name}",
      "arn:aws:s3:::${var.raw_bucket_name}/*"
    ]
  }
  statement {
    sid     = "WriteProcessed"
    actions = ["s3:PutObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.processed_bucket_name}",
      "arn:aws:s3:::${var.processed_bucket_name}/*"
    ]
  }
  statement {
    sid     = "Artifacts"
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.artifacts_bucket_name}",
      "arn:aws:s3:::${var.artifacts_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

# -------- SageMaker role (na później) --------
resource "aws_iam_role" "sagemaker_role" {
  name               = "${var.project}-${var.env}-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json
  tags               = local.common_tags
}

data "aws_iam_policy_document" "sagemaker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

# Minimal S3 access dla treningu/inferencji (rozszerzysz później)
resource "aws_iam_policy" "sagemaker_s3" {
  name   = "${var.project}-${var.env}-sagemaker-s3"
  policy = data.aws_iam_policy_document.sagemaker_s3.json
  tags   = local.common_tags
}

data "aws_iam_policy_document" "sagemaker_s3" {
  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.raw_bucket_name}",
      "arn:aws:s3:::${var.raw_bucket_name}/*",
      "arn:aws:s3:::${var.processed_bucket_name}",
      "arn:aws:s3:::${var.processed_bucket_name}/*",
      "arn:aws:s3:::${var.artifacts_bucket_name}",
      "arn:aws:s3:::${var.artifacts_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "sagemaker_s3_attach" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.sagemaker_s3.arn
}
