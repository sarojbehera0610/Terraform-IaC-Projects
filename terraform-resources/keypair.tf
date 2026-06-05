# GENERATE RSA PRIVATE KEY LOCALLY
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# SAVE PRIVATE KEY AS .pem FILE LOCALLY
resource "local_file" "private_key_pem" {
  content         = tls_private_key.rsa_key.private_key_pem
  filename        = var.private_key_path
  file_permission = "0400"
}

# CREATE AWS KEY PAIR USING PUBLIC KEY
resource "aws_key_pair" "terraform_kp" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# OUTPUTS
output "key_pair_name" {
  description = "Name of the AWS key pair created"
  value       = aws_key_pair.terraform_kp.key_name
}

output "private_key_saved_path" {
  description = "Local path where .pem private key is saved"
  value       = local_file.private_key_pem.filename
}
