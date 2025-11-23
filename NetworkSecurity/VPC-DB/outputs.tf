output "vpc_id" {
  value = module.vpc_prod_db.default_vpc_id
  description = "VPC APP ID"

}