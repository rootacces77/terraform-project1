#PEERING BETWEEN VPC-DB and VPC-APP
resource "aws_vpc_peering_connection" "foo" {
  peer_vpc_id   = var.vpc_prod_app_id
  vpc_id        = var.vpc_prod_db_id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}