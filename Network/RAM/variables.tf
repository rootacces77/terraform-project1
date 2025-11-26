data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  prod_account_id = data.terraform_remote_state.management.outputs.prod_account_id
  security_account_id = data.terraform_remote_state.management.outputs.security_account_id

}

variable "security_subnets" {
  type = list(string)
  description = "Subnets ARNS"
}

variable "prod_subnets" {
  type = list(string)
  description = "Subnets ARNS"
}