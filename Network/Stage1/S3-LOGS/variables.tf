data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}


locals {
  org_id = data.terraform_remote_state.management.outputs.org_id
}

variable "flowlogs_s3_name" {
  type        = string
  description = "Name of the S3 bucket for storing Flow Logs"
  default     = "prod-us-east-1-flowlogs-123456"
}
