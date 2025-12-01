
data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket = "tf-state-project-practice77"
    key    = "accounts/management/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "admin_role_name" {
  type        = string
  default     = "AdminRole"
  description = "Admin role that can read secrets"
}

variable "ec2_secrets_role_name" {
  type        = string
  description = "EC2 instance role that can read secrets"
}