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
# CALLING ASG MODULE
# ──────────────────────────────────────────
module "asg" {
  source = "./modules/asg"

  aws_region              = var.aws_region
  asg_name                = var.asg_name
  environment             = var.environment
  instance_type           = var.instance_type
  key_name                = var.key_name
  allowed_ssh_cidr        = var.allowed_ssh_cidr
  asg_min_size            = var.asg_min_size
  asg_max_size            = var.asg_max_size
  asg_desired_capacity    = var.asg_desired_capacity
  scale_out_cpu_threshold = var.scale_out_cpu_threshold
  scale_in_cpu_threshold  = var.scale_in_cpu_threshold
  cooldown_period         = var.cooldown_period
}
