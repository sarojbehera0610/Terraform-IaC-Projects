variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 bucket name — must be globally unique"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, test)"
  type        = string
}

variable "versioning_status" {
  description = "Versioning status — Enabled or Suspended"
  type        = string
  default     = "Enabled"
}
