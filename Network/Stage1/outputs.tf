output "vpc_app_id" {
  value = module.vpc-app.vpc_id
  description = "VPC APP ID"
}


output "vpc_db_id" {
  value = module.vpc-db.vpc_id
  description = "VPC APP ID"
}
