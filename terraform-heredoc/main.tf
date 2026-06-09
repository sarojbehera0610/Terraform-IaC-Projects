data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "heredoc_sg" {
  name        = "heredoc-sg"
  description = "Allow SSH and HTTP"

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
    Name = "heredoc-sg"
  }
}

resource "aws_instance" "heredoc_demo" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.heredoc_sg.id]

  # HEREDOC used here for multi-line user_data script
  user_data = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y nginx
    echo "<h1>Hello from Terraform Heredoc - Saroj</h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOT

  tags = {
    Name = "heredoc-demo"
  }
}