provider "aws" {
  alias   = "management"
  region  = "us-east-1"
#  profile = "root"
}

terraform {
  backend "s3" {
    bucket         = "tf-state-project-practice77"
    key            = "accounts/management/terraform-stage2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-locks"
    encrypt        = true
  }
}