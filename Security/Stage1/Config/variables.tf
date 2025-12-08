variable "config_bucket_name" {
  description = "Name of the central AWS Config S3 bucket"
  type        = string
}

variable "delivery_frequency" {
  description = "How often AWS Config delivers snapshots"
  type        = string
  default     = "Six_Hours"
}

variable "aws_config_role_arn" {
    type = string
    description = "AWS Config Role ARN"
  
}