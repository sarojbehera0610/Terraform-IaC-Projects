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
# CALLING ALB MODULE
# ──────────────────────────────────────────
module "alb" {
  source = "./modules/alb"

  aws_region        = var.aws_region
  alb_name          = var.alb_name
  tg_name           = var.tg_name
  tg_port           = var.tg_port
  health_check_path = var.health_check_path
  environment       = var.environment
}
