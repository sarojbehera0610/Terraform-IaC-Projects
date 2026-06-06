output "asg_name" {
  description = "Name of the ASG"
  value       = module.asg.asg_name
}

output "asg_arn" {
  description = "ARN of the ASG"
  value       = module.asg.asg_arn
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.asg.launch_template_id
}

output "launch_template_name" {
  description = "Launch Template name"
  value       = module.asg.launch_template_name
}

output "asg_security_group_id" {
  description = "Security Group ID of ASG instances"
  value       = module.asg.asg_security_group_id
}

output "ami_used" {
  description = "AMI ID used"
  value       = module.asg.ami_used
}

output "scale_out_policy_arn" {
  description = "Scale out policy ARN"
  value       = module.asg.scale_out_policy_arn
}

output "scale_in_policy_arn" {
  description = "Scale in policy ARN"
  value       = module.asg.scale_in_policy_arn
}

output "cpu_high_alarm_name" {
  description = "CPU high alarm name"
  value       = module.asg.cpu_high_alarm_name
}

output "cpu_low_alarm_name" {
  description = "CPU low alarm name"
  value       = module.asg.cpu_low_alarm_name
}

output "vpc_id_used" {
  description = "VPC ID used by ASG"
  value       = module.asg.vpc_id_used
}

output "subnets_used" {
  description = "Subnet IDs used by ASG"
  value       = module.asg.subnets_used
}
