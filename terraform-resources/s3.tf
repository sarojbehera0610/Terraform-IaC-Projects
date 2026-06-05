# S3 BUCKET
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

# BLOCK ALL PUBLIC ACCESS
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ENABLE VERSIONING
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# OUTPUTS
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_versioning_status" {
  description = "Versioning status of the S3 bucket"
  value       = aws_s3_bucket_versioning.main.versioning_configuration[0].status
}
