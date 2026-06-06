variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "tg_name" {
  description = "Name of the Target Group"
  type        = string
}

variable "tg_port" {
  description = "Port on which target group receives traffic"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for target group"
  type        = string
  default     = "/"
}

variable "environment" {
  description = "Environment name (dev, prod, test)"
  type        = string
}
