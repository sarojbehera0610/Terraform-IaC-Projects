output "iam_username" {
  description = "IAM username created"
  value       = aws_iam_user.main.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.main.arn
}

output "iam_access_key_id" {
  description = "Access Key ID for programmatic access"
  value       = aws_iam_access_key.main.id
}

output "iam_secret_access_key" {
  description = "Secret Access Key — save immediately shown only once"
  value       = aws_iam_access_key.main.secret
  sensitive   = true
}

output "policy_attached" {
  description = "Policy ARN attached to the user"
  value       = var.policy_arn
}

output "console_access" {
  description = "Whether console login profile was created"
  value       = var.create_login_profile ? "Yes — password reset required on first login" : "No — programmatic access only"
}
