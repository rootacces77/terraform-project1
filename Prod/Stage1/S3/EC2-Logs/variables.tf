variable "ec2_bucket_name" {
  type        = string
  description = "Name of the bucket for storing EC2 logs"
  default     = "prod-us-east-1-ec2app-logs-123456"
}

variable "org_id" {
    type        = string
    description = "AWS Organization ID"
  
}

variable "prod_account_id" {
    type        = string
    description = "ID of Prod Account"
  
}

variable "aws_region_id" {
    type = string
    description = "AWS Region"
  
}