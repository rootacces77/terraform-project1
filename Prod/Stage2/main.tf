module "asg" {
  source = "./ASG-APP"

  app_private_subnet_ids = local.app_private_subnet_ids
  asg_target_group_arn   = local.asg_target_group_arn
  app_template_id        = module.ec2_templates.app_ec2_template_id
} 

module "ec2_templates" {
  source = "./EC2-Templates"

  app_ec2_profile_arn = local.app_ec2_profile_arn
  app_ami_id          = module.ec2_image_builder.ec2_app_ami_id
  ec2_key_name        = local.ec2_key_name
  app_ec2_sg_id       = local.web_sg_id

}

module "ec2_image_builder" {
  source = "./EC2-IMAGE-BUILDER"

  image_builder_profile_name = local.image_builder_profile_name

} 
