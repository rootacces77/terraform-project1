output "vpc_id" {
  value = module.vpc_prod_app.vpc_id
  description = "VPC APP ID"
}


output "security_subnets" {
  value = module.vpc_prod_app.intra_subnet_arns
  description = "Security Subnets"
}

output "prod_subnets" {
  value = module.vpc_prod_app.private_subnet_arns
  description = "Prod Subnets"
}
