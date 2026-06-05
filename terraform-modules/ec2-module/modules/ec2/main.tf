# ──────────────────────────────────────────
# FETCH DEFAULT VPC AUTOMATICALLY
# ──────────────────────────────────────────
data "aws_vpc" "default" {
  default = true
}

# ──────────────────────────────────────────
# FETCH DEFAULT SUBNET AUTOMATICALLY
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
    values = ["${var.aws_region}a"]
  }
}

# ──────────────────────────────────────────
# FETCH LATEST UBUNTU 22.04 AMI AUTOMATICALLY
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
# GENERATE RSA PRIVATE KEY
# ──────────────────────────────────────────
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# ──────────────────────────────────────────
# SAVE .pem FILE LOCALLY
# ──────────────────────────────────────────
resource "local_file" "private_key_pem" {
  content         = tls_private_key.rsa_key.private_key_pem
  filename        = var.private_key_path
  file_permission = "0400"
}

# ──────────────────────────────────────────
# CREATE AWS KEY PAIR
# ──────────────────────────────────────────
resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

# ──────────────────────────────────────────
# SECURITY GROUP — uses default VPC auto fetched
# ──────────────────────────────────────────
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Allow SSH HTTP HTTPS"
  vpc_id      = data.aws_vpc.default.id    # auto fetched

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "${var.instance_name}-sg"
  }
}

# ──────────────────────────────────────────
# EC2 INSTANCE — uses default subnet auto fetched
# ──────────────────────────────────────────
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.default.id    # auto fetched
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.kp.key_name

  depends_on = [aws_key_pair.kp]

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}
