resource "aws_ram_resource_share" "security_subnets_shared" {
  name                      = "security-subnets-shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "security_access" {
  resource_share_arn = aws_ram_resource_share.security_subnets_shared.arn
  principal          = local.security_account_id
  #                OR -> just prod account ID as string:
  # principal = "322059755827"
}


resource "aws_ram_resource_association" "security_subnets" {
  count              = length(local.prod_security_subnets)
  resource_share_arn = aws_ram_resource_share.security_subnets_shared.arn
  resource_arn       = local.prod_security_subnets[count.index]
}
