# ──────────────────────────────────────────
# IAM USER
# ──────────────────────────────────────────
resource "aws_iam_user" "main" {
  name = var.iam_username
  path = "/"

  tags = {
    Name        = var.iam_username
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# ATTACH POLICY TO USER
# policy_arn passed from tfvars
# so dev/prod/test can have different policies
# ──────────────────────────────────────────
resource "aws_iam_user_policy_attachment" "main" {
  user       = aws_iam_user.main.name
  policy_arn = var.policy_arn
}

# ──────────────────────────────────────────
# GENERATE ACCESS KEYS (Programmatic Access)
# ──────────────────────────────────────────
resource "aws_iam_access_key" "main" {
  user       = aws_iam_user.main.name
  depends_on = [aws_iam_user.main]
}

# ──────────────────────────────────────────
# IAM USER LOGIN PROFILE (Console Access)
# only created if create_login_profile = true
# ──────────────────────────────────────────
resource "aws_iam_user_login_profile" "main" {
  count                   = var.create_login_profile ? 1 : 0
  user                    = aws_iam_user.main.name
  password_reset_required = true

  depends_on = [aws_iam_user.main]
}
