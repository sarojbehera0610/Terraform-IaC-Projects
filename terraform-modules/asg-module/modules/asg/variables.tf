variable "aws_region" {
  description = "AWS region"
  type        = string
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
  description = "EC2 instance type for ASG instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access to ASG instances"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
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

variable "scale_out_cpu_threshold" {
  description = "CPU % threshold to trigger scale out"
  type        = number
  default     = 70
}

variable "scale_in_cpu_threshold" {
  description = "CPU % threshold to trigger scale in"
  type        = number
  default     = 30
}

variable "cooldown_period" {
  description = "Cooldown period in seconds between scaling actions"
  type        = number
  default     = 300
}
