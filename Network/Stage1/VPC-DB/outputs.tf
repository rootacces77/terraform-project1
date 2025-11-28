output "vpc_id" {
  value = module.vpc_prod_db.vpc_id
  description = "VPC APP ID"

}


output "prod_db_subnets" {
  value = module.vpc_prod_db.private_subnet_arns
  description = "Prod DB Subnets"
} 
