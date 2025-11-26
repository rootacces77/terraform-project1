terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}

provider "aws" {

  region = "us-east-1"

  assume_role {
    # This is the role you created IN THE NETWORK ACCOUNT
    role_arn     = "arn:aws:iam::796796207799:role/AdminRole"
    session_name = "tf-network"
  }
}

######
