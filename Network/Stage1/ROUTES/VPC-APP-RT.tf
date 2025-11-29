resource "aws_route" "prod_app_private_peering_route" {
  route_table_id         = var.app_private_rt_id
  destination_cidr_block = var.vpc_db_cidr
  vpc_peering_connection_id = var.vpc_peering_id
}