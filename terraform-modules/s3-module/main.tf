terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ──────────────────────────────────────────
# CALLING S3 MODULE
# ──────────────────────────────────────────
module "s3" {
  source = "./modules/s3"

  bucket_name       = var.bucket_name
  environment       = var.environment
  versioning_status = var.versioning_status
}
