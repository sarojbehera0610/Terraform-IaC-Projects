variable "iam_username" {
  description = "IAM username to create"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, test)"
  type        = string
}

variable "policy_arn" {
  description = "IAM policy ARN to attach to the user"
  type        = string
}

variable "create_login_profile" {
  description = "Whether to create console login profile for the user"
  type        = bool
  default     = false
}
