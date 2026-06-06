variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
}

variable "tg_port" {
  description = "Port for target group"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "environment" {
  description = "Environment name (dev, prod, test)"
  type        = string
}
