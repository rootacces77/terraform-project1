output "vpc_id" {
  value = module.vpc_prod_app.vpc_id
  description = "VPC APP ID"
}


output "prod_security_subnets" {
  value = module.vpc_prod_app.intra_subnet_arns
  description = "Security Subnets"
}

output "prod_private_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Subnets"
} 


output "prod_app_private_rt_id" {
  value       = module.vpc_prod_app.private_route_table_ids[0]
  description = "Private Route Table for PROD APP VPC"
}


output "vpc_cidr" {
  value = module.vpc_prod_app.vpc_cidr_block
  description = "CIDR of VPC APP"
}










/*
output "prod_private_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Private Subnets"
} */
