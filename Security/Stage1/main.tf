module "s3" {
    source = "./S3"

    org_id                = local.org_id
    management_account_id = local.management_account_id
    security_account_id   = local.security_account_id

  
}

module "cloudtrail" {
    source = "./CloudTrail"

    s3_cloudtrail_logs_id = module.s3.s3_cloudtrail_logs_id
  
}

/* module "firewall_manager" {
    source = "./FirewallManager"

    prod_account_id    = local.prod_account_id
    network_account_id =  local.network_account_id
  
} */

module "iam" {
    source = "./IAM"

    s3_config_arn = module.s3.s3_config_logs_arn
  
}

module "aws_config" {
    source = "./Config"
  
    config_bucket_name  = module.s3.s3_config_logs_name
    aws_config_role_arn = module.iam.aws_config_role_arn
}