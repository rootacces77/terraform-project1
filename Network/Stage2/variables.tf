data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
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


data "terraform_remote_state" "prod" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/prod/terraform.tfstate"
    region = "us-east-1"
  }
}



locals {
  network_account_id         = data.terraform_remote_state.management.outputs.network_account_id
  cf_dns                     = data.terraform_remote_state.prod.outputs.cf_dns
  cf_hosted_zone_id          = data.terraform_remote_state.prod.outputs.cf_hosted_zone_id
  prod_app_vpc_id            = data.terraform_remote_state.network.outputs.vpc_app_id
  ec2_db_dns                 = data.terraform_remote_state.prod.outputs.ec2_db_dns
  r53_zone_id                = data.terraform_remote_state.management.outputs.domain_zone_id
  network_route53_role_arn   = data.terraform_remote_state.management.outputs.network_route53_role_arn
}
