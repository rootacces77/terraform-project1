/*output "prod_db_vpc_id" {
  value = module.vpc_prod_db.id
  description = "VPC DB ID"

} */

output "vpc_id" {
  value = aws_vpc.vpc_prod_db.id
  description = "VPC DB ID"
} 

output "vpc_cidr" {
  value       = aws_vpc.vpc_prod_db.cidr_block
  description = "CIDR block of PROD DB VPC"
}

output "prod_db_subnets" {
  value       = [for s in aws_subnet.prod_db_private : s.arn]
  description = "Prod DB Subnet ARNs"
}

output "prod_db_rt_id" {
  value       = aws_route_table.prod_db_private.id
  description = "Prod DB Route Table"
}
/*output "prod_db_subnets" {
  value = aws_vpc.vpc_prod_db.private_subnet_arns
  description = "Prod DB Subnets"
} */
