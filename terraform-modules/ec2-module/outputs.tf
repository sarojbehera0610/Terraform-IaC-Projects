output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.ec2_instance_id
}

output "ec2_public_ip" {
  description = "Public IP of EC2"
  value       = module.ec2.ec2_public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of EC2"
  value       = module.ec2.ec2_public_dns
}

output "ami_used" {
  description = "AMI ID used"
  value       = module.ec2.ami_used
}

output "key_pair_name" {
  description = "Key pair name"
  value       = module.ec2.key_pair_name
}

output "security_group_id" {
  description = "Security group ID"
  value       = module.ec2.security_group_id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = module.ec2.ssh_command
}
