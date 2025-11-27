terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/prod/terraform-stage2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}

provider "aws" {

  region = "us-east-1"

  assume_role {
    # This is the role you created IN THE PROD ACCOUNT
    role_arn     = "arn:aws:iam::771611221901:role/AdminRole"
    session_name = "tf-prod"
  }
}