terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ──────────────────────────────────────────
# CALLING EC2 MODULE
# ──────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  aws_region       = var.aws_region
  instance_name    = var.instance_name
  instance_type    = var.instance_type
  allowed_ssh_cidr = var.allowed_ssh_cidr
  key_name         = var.key_name
  private_key_path = var.private_key_path
  volume_size      = var.volume_size
}
