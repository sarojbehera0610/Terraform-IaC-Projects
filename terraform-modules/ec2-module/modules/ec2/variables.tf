variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "instance_name" {
  description = "Name tag for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}


variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "Name for the AWS key pair"
  type        = string
}

variable "private_key_path" {
  description = "Local path to save .pem file"
  type        = string
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}
