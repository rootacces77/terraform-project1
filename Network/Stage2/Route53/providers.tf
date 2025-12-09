
provider "aws" {
  alias = "route53-role"
  region = "us-east-1"

  assume_role {
    role_arn     = var.network_route53_role_arn
    session_name = "tf-network"
  }
}
