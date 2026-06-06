variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, test)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing AWS key pair name for SSH"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "asg_min_size" {
  description = "Minimum instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum instances in ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired instances in ASG"
  type        = number
  default     = 2
}

variable "scale_out_cpu_threshold" {
  description = "CPU % to trigger scale out"
  type        = number
  default     = 70
}

variable "scale_in_cpu_threshold" {
  description = "CPU % to trigger scale in"
  type        = number
  default     = 30
}

variable "cooldown_period" {
  description = "Seconds to wait between scaling actions"
  type        = number
  default     = 300
}
