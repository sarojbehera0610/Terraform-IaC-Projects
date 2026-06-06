output "iam_username" {
  description = "IAM username created"
  value       = module.iam.iam_username
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = module.iam.iam_user_arn
}

output "iam_access_key_id" {
  description = "Access Key ID"
  value       = module.iam.iam_access_key_id
}

output "iam_secret_access_key" {
  description = "Secret Access Key — save immediately"
  value       = module.iam.iam_secret_access_key
  sensitive   = true
}

output "policy_attached" {
  description = "Policy attached to user"
  value       = module.iam.policy_attached
}

output "console_access" {
  description = "Console access status"
  value       = module.iam.console_access
}
