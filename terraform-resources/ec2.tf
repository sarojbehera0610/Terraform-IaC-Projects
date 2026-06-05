# FETCH LATEST UBUNTU 22.04 AMI AUTOMATICALLY
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical official

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 INSTANCE
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.terraform_kp.key_name

  depends_on = [aws_key_pair.terraform_kp]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}

# OUTPUTS
output "ec2_instance_id" {
  description = "Instance ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.ec2.public_dns
}

output "ami_used" {
  description = "AMI ID that was actually used to launch the instance"
  value       = data.aws_ami.ubuntu.id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.ec2.public_ip}"
}
