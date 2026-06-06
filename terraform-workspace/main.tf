terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# ──────────────────────────────────────────
# FETCH LATEST UBUNTU AMI
# ──────────────────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ──────────────────────────────────────────
# FETCH DEFAULT VPC
# ──────────────────────────────────────────
data "aws_vpc" "default" {
  default = true
}

# ──────────────────────────────────────────
# FETCH DEFAULT SUBNET
# ──────────────────────────────────────────
data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availabilityZone"
    values = ["ap-south-1a"]
  }
}

# ──────────────────────────────────────────
# GENERATE KEY PAIR
# ──────────────────────────────────────────
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.rsa_key.private_key_pem
  filename        = "./${terraform.workspace}-keypair.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "kp" {
  key_name   = "${terraform.workspace}-keypair"
  public_key = tls_private_key.rsa_key.public_key_openssh

  tags = {
    Name        = "${terraform.workspace}-keypair"
    Environment = terraform.workspace
  }
}

# ──────────────────────────────────────────
# SECURITY GROUP
# ──────────────────────────────────────────
resource "aws_security_group" "sg" {
  name        = "${terraform.workspace}-sg"
  description = "SG for ${terraform.workspace} workspace"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${terraform.workspace}-sg"
    Environment = terraform.workspace
  }
}

# ──────────────────────────────────────────
# EC2 INSTANCE
# terraform.workspace automatically gives
# current workspace name — dev, prod, test
# so each workspace creates its own instance
# with no conflict
# ──────────────────────────────────────────
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = terraform.workspace == "prod" ? "t3.small" : "t3.micro"
  subnet_id              = data.aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = aws_key_pair.kp.key_name

  tags = {
    Name        = "${terraform.workspace}-ec2-instance"
    Environment = terraform.workspace
  }
}

# ──────────────────────────────────────────
# OUTPUTS
# ──────────────────────────────────────────
output "workspace_name" {
  description = "Current active workspace"
  value       = terraform.workspace
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.ec2.id
}

output "instance_public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.ec2.public_ip
}

output "ssh_command" {
  description = "SSH command"
  value       = "ssh -i ./${terraform.workspace}-keypair.pem ubuntu@${aws_instance.ec2.public_ip}"
}
