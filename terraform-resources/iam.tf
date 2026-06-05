# IAM USER
resource "aws_iam_user" "admin_user" {
  name = var.iam_username
  path = "/"

  tags = {
    Name = var.iam_username
  }
}

# ATTACH AdministratorAccess POLICY
resource "aws_iam_user_policy_attachment" "admin_policy" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# GENERATE ACCESS KEYS
resource "aws_iam_access_key" "admin_keys" {
  user       = aws_iam_user.admin_user.name
  depends_on = [aws_iam_user.admin_user]
}

# OUTPUTS
output "iam_username" {
  description = "IAM username created"
  value       = aws_iam_user.admin_user.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.admin_user.arn
}

output "iam_access_key_id" {
  description = "Access Key ID"
  value       = aws_iam_access_key.admin_keys.id
}

output "iam_secret_access_key" {
  description = "Secret Access Key — save immediately, shown only once"
  value       = aws_iam_access_key.admin_keys.secret
  sensitive   = true
}
