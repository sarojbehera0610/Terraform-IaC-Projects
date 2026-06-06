output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = module.s3.bucket_domain_name
}

output "versioning_status" {
  description = "Versioning status"
  value       = module.s3.versioning_status
}

output "encryption_status" {
  description = "Encryption status"
  value       = module.s3.encryption_status
}
