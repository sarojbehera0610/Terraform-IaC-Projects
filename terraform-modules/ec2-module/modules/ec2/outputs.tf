output "ec2_instance_id" {
  description = "ID of the EC2 instance"
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
  description = "AMI ID used to launch the instance"
  value       = data.aws_ami.ubuntu.id
}

output "key_pair_name" {
  description = "Key pair name created"
  value       = aws_key_pair.kp.key_name
}

output "security_group_id" {
  description = "Security group ID attached to EC2"
  value       = aws_security_group.ec2_sg.id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.ec2.public_ip}"
}
