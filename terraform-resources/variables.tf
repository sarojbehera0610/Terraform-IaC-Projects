# PROVIDER
variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "ap-south-1"
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "terraform-vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
  default     = "public-subnet"
}

# SECURITY GROUP
variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "web-sg"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

# KEY PAIR
variable "key_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "terraform-keypair"
}

variable "private_key_path" {
  description = "Local path to save the generated .pem private key"
  type        = string
  default     = "./terraform-keypair.pem"
}

# EC2

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "terraform-ec2"
}

# S3
variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = "saroj-terraform-bucket-2026"
}

# IAM
variable "iam_username" {
  description = "IAM username to create"
  type        = string
  default     = "terraform-admin-user"
}

#PUBLIC SUBNET 2
variable "public_subnet2_cidr" {
  description = "CIDR for second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# ALB
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "terraform-alb"
}

variable "tg_name" {
  description = "Name of the ALB target group"
  type        = string
  default     = "terraform-tg"
}

# ASG
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "terraform-asg"
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}
