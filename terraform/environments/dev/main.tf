module "s3" {
  source  = "../../modules/s3-buckets"
  project = "ctds"
  env     = "dev"
}

module "iam" {
  source                 = "../../modules/iam"
  project                = "ctds"
  env                    = "dev"
  raw_bucket_name        = module.s3.raw_bucket
  processed_bucket_name  = module.s3.processed_bucket
  artifacts_bucket_name  = module.s3.artifacts_bucket
}

output "raw_bucket"       { value = module.s3.raw_bucket }
output "processed_bucket" { value = module.s3.processed_bucket }
output "artifacts_bucket" { value = module.s3.artifacts_bucket }
output "lambda_role_arn"  { value = module.iam.lambda_role_arn }
output "sm_role_arn"      { value = module.iam.sagemaker_role_arn }
