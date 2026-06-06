output "alb_dns_name" {
  description = "DNS name of the ALB — use this to access your app"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "alb_name" {
  description = "Name of the ALB"
  value       = aws_lb.main.name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.main.name
}

output "listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  description = "Security group ID attached to ALB"
  value       = aws_security_group.alb_sg.id
}

output "vpc_id_used" {
  description = "VPC ID used by ALB — auto fetched default VPC"
  value       = data.aws_vpc.default.id
}

output "subnets_used" {
  description = "Subnet IDs used by ALB — auto fetched default subnets"
  value       = data.aws_subnets.default.ids
}
