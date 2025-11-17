terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region  = "us-east-1"
  profile = "root"
}

module "accounts" {
  source = "./Organization"

}

module "tfstate" {
  source = "./tfstate"

}