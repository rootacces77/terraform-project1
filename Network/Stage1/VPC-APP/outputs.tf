output "vpc_id" {
  value = aws_vpc.vpc_prod_app.id
  description = "VPC APP ID"
}


output "prod_security_subnets" {
  value = [for s in aws_subnet.prod_app_security : s.arn]
  description = "Security Subnets"
}

output "prod_private_subnets" {
  value = [for s in aws_subnet.prod_app_private : s.arn]
  description = "Prod Subnets"
} 


output "prod_app_private_rt_id" {
  value       = aws_route_table.prod_app_private
  description = "Private Route Table for PROD APP VPC"
}


output "vpc_cidr" {
  value = aws_vpc.vpc_prod_app.cidr_block
  description = "CIDR of VPC APP"
}










/*
output "prod_private_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Private Subnets"
} */
