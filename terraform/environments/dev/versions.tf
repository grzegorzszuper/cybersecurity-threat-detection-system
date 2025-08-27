terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }

  cloud {
    organization = "Terraform-nauka"
    workspaces {
      name = "cybersecurity-threat-detection-system"
    }
  }
}
