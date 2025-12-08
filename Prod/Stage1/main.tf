module "ec2_image_builder" {
  source = "./EC2-IMAGE-BUILDER"

  secret_reader_policy_arn = module.iam.secret_reader_policy_arn
} 

module "iam" {
  source = "./IAM"
}

module "secret_manager" {
    source = "./SecretManager"  


    ec2_secrets_role_arn = module.iam.app_ec2_role_arn
    db_username          = var.db_user
    db_password          = var.db_password

}

module "kms" {
    source = "./KMS"
    secret_manager_pk_id = module.secret_manager.ec2_pk_secret_id
}

module "acm" {
    source = "./ACM"  
}

module "security_groups" {
    source = "./SecurityGroups"
}

module "alb" {
  source  = "./ALB-APP"

  vpc_id              = data.terraform_remote_state.network.outputs.vpc_app_id
  alb_sg_id           = module.security_groups.alb_sg_id
  acm_certificate_arn = module.acm.prod_cert_arn
  alb_subnets         = data.terraform_remote_state.network.outputs.prod_app_public_subnets_ids
}

module "ec2_templates" {
  source = "./EC2-Templates"

  app_ec2_profile_arn = module.iam.app_ec2_profile_arn
  app_ami_id          = module.ec2_image_builder.ec2_app_ami_id
  ec2_key_name        = module.kms.ec2_key_name
  app_ec2_sg_id       = module.security_groups.web_sg_id

  
}

module "asg" {
  source = "./ASG-APP"

  app_private_subnet_ids = data.terraform_remote_state.network.outputs.prod_app_private_subnets_ids
  asg_target_group_arn   = module.alb.target_group_id
  app_template_id        = module.ec2_templates.app_ec2_template_id
  
}

module "ec2-db" {
  source = "./EC2-DB"

  subnet_id             = data.terraform_remote_state.network.outputs.prod_db_private_subnets_ids[0]
  key_name              = module.kms.ec2_key_name
  instance_profile_name = module.iam.app_ec2_profile_name
  security_group_id     = module.security_groups.db_sg_id
  db_ami_id             = module.ec2_image_builder.ec2_db_ami_id
  
} 

module "s3" {
  source = "./S3"

  prod_account_id = local.prod_account_id
  aws_region_id =  data.aws_region.current.id
  org_id = data.terraform_remote_state.management.outputs.org_id
  
}

module "cloudfront" {
  source = "./CloudFront"

  s3_bucket_regional_domain_name = module.s3.s3_cf_origin_regional_domain_name
  s3_cf_origin_arn               = module.s3.s3_cf_origin_arn
  s3_cf_origin_id                = module.s3.s3_cf_origin_id
  acm_certificate_arn            = module.acm.prod_cert_arn
  prod_account_id                = local.prod_account_id
  alb_dns_name                   = module.alb.alb_dns_name

  
}

module "cloudwatch" {
  source = "./CloudWatch"

  logs_bucket_arn = module.s3.s3_ec2_logs_arn
  logs_bucket_name = module.s3.s3_ec2_logs_regional_domain_name
  aws_region_id    = data.aws_region.current.id
  prod_account_id  = local.prod_account_id
}