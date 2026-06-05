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

# CALLING THE VPC MODULE
module "vpc" {
  source = "./modules/vpc"

  aws_region          = var.aws_region
  vpc_cidr            = var.vpc_cidr
  vpc_name            = var.vpc_name
  public_subnet_cidr  = var.public_subnet_cidr
  public_subnet2_cidr = var.public_subnet2_cidr
}
