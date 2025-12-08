
provider "aws" {
  alias = "route53-role"
  region = "us-east-1"

  assume_role {
    # This is the role you created IN THE NETWORK ACCOUNT
    role_arn     = "arn:aws:iam::${var.network_account_id}:role/AdminRole"
    session_name = "tf-network"
  }
}
