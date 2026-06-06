output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.arn
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.main.id
}

output "launch_template_name" {
  description = "Name of the Launch Template"
  value       = aws_launch_template.main.name
}

output "asg_security_group_id" {
  description = "Security Group ID attached to ASG instances"
  value       = aws_security_group.asg_sg.id
}

output "ami_used" {
  description = "AMI ID used in Launch Template"
  value       = data.aws_ami.ubuntu.id
}

output "scale_out_policy_arn" {
  description = "ARN of scale out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of scale in policy"
  value       = aws_autoscaling_policy.scale_in.arn
}

output "cpu_high_alarm_name" {
  description = "CloudWatch alarm name for CPU high"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "cpu_low_alarm_name" {
  description = "CloudWatch alarm name for CPU low"
  value       = aws_cloudwatch_metric_alarm.cpu_low.alarm_name
}

output "vpc_id_used" {
  description = "Default VPC ID used by ASG"
  value       = data.aws_vpc.default.id
}

output "subnets_used" {
  description = "Default subnet IDs used by ASG"
  value       = data.aws_subnets.default.ids
}
