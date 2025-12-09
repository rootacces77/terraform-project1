
provider "aws" {
  alias = "route53-role"
  region = "us-east-1"

  assume_role {
    # This is the role you created IN THE NETWORK ACCOUNT
    role_arn     = var.network_route53_role_arn
    session_name = "tf-network"
  }
}
