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















/*
output "prod_private_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Private Subnets"
} */
