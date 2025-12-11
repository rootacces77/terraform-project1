module "asg" {
  source = "./ASG-APP"

  app_private_subnet_ids = data.terraform_remote_state.network.outputs.prod_app_private_subnets_ids
  asg_target_group_arn   = data.terraform_remote_state.prod.outputs.target_group_id
  app_template_id        = data.terraform_remote_state.prod.outputs.app_ec2_template_id
}