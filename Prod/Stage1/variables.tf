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

locals {
  prod_account_id = data.terraform_remote_state.management.outputs.prod_account_id
}

variable "db_user" {
  type        = string
  description = "DB USERNAME"
  default     = "terraform"
  
}

variable "db_password" {
  type        = string
  description = "DB PASSWORD"
  default     = "terraform"
  
}