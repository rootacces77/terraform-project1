data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  management_account_id = data.terraform_remote_state.management.outputs.management_account_id
  org_id                = data.terraform_remote_state.management.outputs.org_id 
}