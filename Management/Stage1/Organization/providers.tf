provider "aws" {
  alias  = "prod"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.prod_account_id}:role/OrganizationAccountAccessRole"
    session_name = "tf-bootstrap"
  }
}

provider "aws" {
  alias  = "dev"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.dev_account_id}:role/OrganizationAccountAccessRole"
    session_name = "tf-bootstrap"
  }
}

provider "aws" {
  alias  = "network"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.network_account_id}:role/OrganizationAccountAccessRole"
    session_name = "tf-bootstrap"
  }
}

provider "aws" {
  alias  = "security"
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.security_account_id}:role/OrganizationAccountAccessRole"
    session_name = "tf-bootstrap"
  }
}

provider "aws" {
  alias = "management"
  region = "us-east-1"
#  profile = "root"
}