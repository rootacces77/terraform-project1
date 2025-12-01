data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate" # adjust path
    region = "us-east-1"
  }
}

# Second provider = Management account, assumed via Route53 ACM role
provider "aws" {
  alias  = "mgmt_dns"
  region = "us-east-1"

  assume_role {
    role_arn     = data.terraform_remote_state.management.outputs.prod_route53_role_arn
    session_name = "prod-acm-dns-validation"
  }
}