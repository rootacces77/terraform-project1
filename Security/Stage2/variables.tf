data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  security_account_id   = data.terraform_remote_state.management.outputs.security_account_id
  prod_account_id       = data.terraform_remote_state.management.outputs.prod_account_id
  network_account_id       = data.terraform_remote_state.management.outputs.network_account_id

  s3_config_logs_name   = data.terraform_remote_state.security.outputs.s3_config_logs_name
  aws_config_role_arn   = data.terraform_remote_state.security.outputs.aws_config_role_arn

}