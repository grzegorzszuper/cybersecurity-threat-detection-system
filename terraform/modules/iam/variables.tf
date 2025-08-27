variable "project" { type = string }
variable "env"     { type = string }

variable "raw_bucket_name" {
  description = "Raw logs bucket name"
  type        = string
}

variable "processed_bucket_name" {
  description = "Processed logs bucket name"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Artifacts bucket name (for SM models, lambda zips)"
  type        = string
}
