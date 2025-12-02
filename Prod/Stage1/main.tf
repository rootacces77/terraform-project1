/*module "ec2-image-builder" {
  source = "./EC2-IMAGE-BUILDER"
} */

module "iam" {
  source = "./IAM"
}

module "secret_manager" {
    source = "./SecretManager"  
    ec2_secrets_role_name = module.iam.ec2_secret_manager_role_name
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