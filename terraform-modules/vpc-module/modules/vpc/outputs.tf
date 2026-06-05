output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public.id
}

output "public_subnet2_id" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public2.id
}

output "igw_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "ID of public route table"
  value       = aws_route_table.public_rt.id
}
