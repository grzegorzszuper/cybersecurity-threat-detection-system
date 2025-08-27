output "raw_bucket" {
  value       = aws_s3_bucket.raw.bucket
  description = "Name of the raw logs bucket"
}

output "processed_bucket" {
  value       = aws_s3_bucket.processed.bucket
  description = "Name of the processed logs bucket"
}

output "artifacts_bucket" {
  value       = aws_s3_bucket.artifacts.bucket
  description = "Name of the artifacts bucket"
}
