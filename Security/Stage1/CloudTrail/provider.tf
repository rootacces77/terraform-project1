provider "aws" {
  alias = "management"

  region = "us-east-1"

  assume_role {
    # This is the role you created IN THE SECURITY ACCOUNT
    role_arn     = "arn:aws:iam::${var.management_account_id}:role/GitHubActionsTerraformRole"
    session_name = "tf-network"
  }
}