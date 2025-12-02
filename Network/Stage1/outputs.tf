output "vpc_app_id" {
  value = module.vpc-app.vpc_id
  description = "VPC APP ID"
}


output "vpc_db_id" {
  value = module.vpc-db.vpc_id
  description = "VPC APP ID"
}


output "prod_app_public_subnets_ids" {
  value =  module.vpc-app.prod_app_public_subnets_ids
  description = "ID's of Public Subnets "
  
}

output "prod_app_private_subnets_ids" {
  value =  module.vpc-app.prod_app_private_subnets_ids
  description = "ID's of Private Subnets "
  
}

output "prod_app_security_subnets_ids" {
  value =  module.vpc-app.prod_app_security_subnets_ids
  description = "ID's of Security Subnets "
  
}