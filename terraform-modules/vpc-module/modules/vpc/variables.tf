variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet 1"
  type        = string
}

variable "public_subnet2_cidr" {
  description = "CIDR for public subnet 2"
  type        = string
}
