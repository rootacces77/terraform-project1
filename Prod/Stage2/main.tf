module "asg" {
  source = "./ASG-APP"

  app_private_subnet_ids = local.app_private_subnet_ids
  asg_target_group_arn   = local.asg_target_group_arn
  app_template_id        = local.app_template_id
} 