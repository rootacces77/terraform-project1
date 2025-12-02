output "vpc_id" {
  value = aws_vpc.vpc_prod_app.id
  description = "VPC APP ID"
}


output "prod_security_subnets" {
  value = [for s in aws_subnet.prod_app_security : s.arn]
  description = "ARN of Security Subnets"
}

output "prod_app_subnets" {
    value = concat(
    [for s in aws_subnet.prod_app_private : s.arn],
    [for s in aws_subnet.prod_app_public : s.arn]
  )
  description = "ARN of Prod APP Subnets"
} 


output "prod_app_private_rt_id" {
  value       = aws_route_table.prod_app_private.id
  description = "Private Route Table for PROD APP VPC"
}


output "vpc_cidr" {
  value = aws_vpc.vpc_prod_app.cidr_block
  description = "CIDR of VPC APP"
}


output "prod_app_public_subnets_ids" {
  value =  [for s in aws_subnet.prod_app_public : s.arn]
  description = "ID's of Public Subnets "
  
}

output "prod_app_private_subnets_ids" {
  value =  [for s in aws_subnet.prod_app_private : s.arn]
  description = "ID's of Private Subnets "
  
}

output "prod_app_security_subnets_ids" {
  value =  [for s in aws_subnet.prod_app_security : s.arn]
  description = "ID's of Security Subnets "
  
}








/*
output "prod_private_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Private Subnets"
} */
