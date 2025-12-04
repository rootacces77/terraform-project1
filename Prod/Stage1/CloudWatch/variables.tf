variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
  default     = "app"
}

variable "ec2_log_group_name" {
  type        = string
  description = "CloudWatch Log Group name that EC2 CloudWatch Agent will write into"
  default     = "/ec2/app"
}

variable "logs_bucket_name" {
  type        = string
  description = "Existing S3 bucket name for log delivery"
}

variable "logs_bucket_arn" {
  type        = string
  description = "Existing S3 bucket ARN for log delivery"
}

variable "s3_prefix" {
  type        = string
  description = "Prefix inside the S3 bucket"
  default     = "ec2-logs/"
}

variable "log_retention_days" {
  type        = number
  description = "CW Logs retention days"
  default     = 30
}

variable "cloudwatch_logs_kms_key_arn" {
  type        = string
  description = "Optional KMS key ARN for CloudWatch Logs encryption (null to disable)"
  default     = null
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "aws_region_id" {
    type = string
    description = "AWS Region"
  
}

variable "prod_account_id" {
    type        = string
    description = "ID of Prod Account"
  
}