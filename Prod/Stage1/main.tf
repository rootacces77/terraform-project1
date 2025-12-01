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

