# ──────────────────────────────────────────
# REMOTE BACKEND — stores tfstate in S3
# Run: terraform init after adding this
# ──────────────────────────────────────────
terraform {
  backend "s3" {
    bucket  = "saroj-terraform-remote-backend-2026"   # your S3 bucket name
    key     = "workspace/terraform.tfstate"            # path inside bucket
    region  = "ap-south-1"
    encrypt = true                                     # encrypts state file in S3
  }
}
