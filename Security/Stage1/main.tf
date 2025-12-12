module "s3" {
    source = "./S3"

    org_id                = local.org_id
    management_account_id = local.management_account_id
    security_account_id   = local.security_account_id

  
}

module "cloudtrail" {
    source = "./CloudTrail"

    s3_cloudtrail_logs_id = module.s3.s3_cloudtrail_logs_id
    management_account_id = local.management_account_id
  
}

module "iam" {
    source = "./IAM"

    s3_config_arn = module.s3.s3_config_logs_arn
  
}
