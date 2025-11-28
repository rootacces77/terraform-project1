resource "aws_ram_resource_share" "prod_subnets_shared" {
  name                      = "prod-subnets-shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "prod_access" {
  resource_share_arn = aws_ram_resource_share.prod_subnets_shared.arn
  principal          = local.prod_account_id
  #                OR -> just prod account ID as string:
  # principal = "322059755827"
}


resource "aws_ram_resource_association" "prod_subnets" {
  count              = length(var.prod_private_subnets)
  resource_share_arn = aws_ram_resource_share.prod_subnets_shared.arn
  resource_arn       = var.prod_private_subnets[count.index]
}
