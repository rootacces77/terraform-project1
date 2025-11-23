output "vpc_id" {
  value = module.vpc_prod_app.default_vpc_id
  description = "VPC APP ID"

}