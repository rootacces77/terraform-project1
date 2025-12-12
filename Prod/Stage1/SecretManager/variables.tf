
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

variable "ec2_secrets_role_arn" {
  type        = string
  description = "EC2 instance role that can read secrets"
}

variable "web_builder_role_arn" {
  type = string
  description = "ARN of web builder role"
  
}

variable "db_username" {
  type        = string
  description = "Username of Database User"
}

variable "db_password" {
  type = string
  description = "Password of Database User"
  
}