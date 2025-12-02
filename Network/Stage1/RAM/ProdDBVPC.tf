resource "aws_ram_resource_share" "prod_db_subnets_shared" {
  name                      = "prod-db-subnets-shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "prod_db_access" {
  resource_share_arn = aws_ram_resource_share.prod_db_subnets_shared.arn
  principal          = local.prod_account_id
  #                OR -> just prod account ID as string:
  # principal = "322059755827"
}


resource "aws_ram_resource_association" "db_subnets" {
  count              = length(var.prod_db_subnets)
  resource_share_arn = aws_ram_resource_share.prod_db_subnets_shared.arn
  resource_arn       = var.prod_db_subnets[count.index]
}
