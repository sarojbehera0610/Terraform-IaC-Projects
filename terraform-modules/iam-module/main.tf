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
# CALLING IAM MODULE
# ──────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  iam_username         = var.iam_username
  environment          = var.environment
  policy_arn           = var.policy_arn
  create_login_profile = var.create_login_profile
}
