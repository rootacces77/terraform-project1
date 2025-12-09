module "route53" {
  source = "./Route53"

  ec2_db_dns               = local.ec2_db_dns
  cf_zone_id               = local.cf_hosted_zone_id
  network_account_id       = local.network_account_id
  prod_app_vpc_id          = local.prod_app_vpc_id
  r53_zone_id              = local.r53_zone_id
  cf_domain_name           = local.cf_dns
  network_route53_role_arn = local.network_route53_role_arn
}