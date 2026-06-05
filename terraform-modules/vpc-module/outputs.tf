output "vpc_id" {
  description = "VPC ID created by module"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet 1 ID"
  value       = module.vpc.public_subnet_id
}

output "public_subnet2_id" {
  description = "Public subnet 2 ID"
  value       = module.vpc.public_subnet2_id
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.igw_id
}

output "public_route_table_id" {
  description = "Route table ID"
  value       = module.vpc.public_route_table_id
}
