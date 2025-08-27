output "lambda_role_arn" {
  value       = aws_iam_role.lambda_role.arn
  description = "IAM role ARN for the preprocess Lambda"
}

output "sagemaker_role_arn" {
  value       = aws_iam_role.sagemaker_role.arn
  description = "IAM role ARN for SageMaker jobs"
}
