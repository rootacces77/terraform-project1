data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/prod/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  prod_account_id        = data.terraform_remote_state.management.outputs.prod_account_id
  app_private_subnet_ids = data.terraform_remote_state.network.outputs.prod_app_private_subnets_ids
  asg_target_group_arn   = data.terraform_remote_state.prod.outputs.target_group_id
  app_template_id        = data.terraform_remote_state.prod.outputs.app_ec2_template_id
}
