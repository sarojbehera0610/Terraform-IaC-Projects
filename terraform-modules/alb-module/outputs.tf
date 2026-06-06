output "alb_dns_name" {
  description = "DNS name of ALB — open this in browser"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.alb_arn
}

output "alb_name" {
  description = "Name of the ALB"
  value       = module.alb.alb_name
}

output "target_group_arn" {
  description = "ARN of target group"
  value       = module.alb.target_group_arn
}

output "target_group_name" {
  description = "Name of target group"
  value       = module.alb.target_group_name
}

output "listener_arn" {
  description = "ARN of HTTP listener"
  value       = module.alb.listener_arn
}

output "alb_security_group_id" {
  description = "Security group ID of ALB"
  value       = module.alb.alb_security_group_id
}

output "vpc_id_used" {
  description = "VPC ID used — auto fetched"
  value       = module.alb.vpc_id_used
}

output "subnets_used" {
  description = "Subnet IDs used — auto fetched"
  value       = module.alb.subnets_used
}
