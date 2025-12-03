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
  #app_ami_id          = module.ec2_image_builder.
  ec2_key_name        = module.kms.ec2_key_name
  app_ec2_sg_id       = module.security_groups.web_sg_id

  
}

module "asg" {
  source = "./ASG-APP"

  app_private_subnet_ids = data.terraform_remote_state.network.outputs.prod_app_private_subnets_ids
  asg_target_group_arn   = module.alb.target_group_id
  app_template_id        = module.ec2_templates.app_ec2_template_id
  
}