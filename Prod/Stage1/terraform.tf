terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}

provider "aws" {

  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.prod_account_id}:role/AdminRole"
    session_name = "tf-prod"
  }
}

