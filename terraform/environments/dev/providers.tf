provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project    = "CTDS"
      Env        = "dev"
      Owner      = "you"
      CostCenter = "Security"
    }
  }
}
