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
  prod_account_id = data.terraform_remote_state.management.outputs.prod_account_id
}























variable "app_private_subnet_ids" {
    type        = list(string)
    description = "Auto Scaling Group Subnets"
  
}

variable "asg_target_group_arn" {
  type        = string
  description = "Target Group ARN of ASG"
}

variable "app_template_id" {
  type        = string
  description = "ID of APP template"
}