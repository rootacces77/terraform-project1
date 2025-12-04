############################
# Variables (inputs)
############################
variable "acm_certificate_arn" {
  type        = string
  description = "Existing ACM cert ARN (MUST be in us-east-1 for CloudFront)"
}

variable "aliases" {
  type        = list(string)
  description = "Custom domain names for CloudFront (e.g. [\"app.example.com\"])"
  default     = []
}

variable "alb_dns_name" {
  type        = string
  description = "Existing ALB DNS name (e.g. module.alb.dns_name)"
}

variable "s3_bucket_regional_domain_name" {
  type        = string
  description = "Existing S3 bucket regional domain name (e.g. module.s3_cf_origin.s3_bucket_bucket_regional_domain_name)"
}

variable "s3_cf_origin_arn" {
    type = string
    description = "ARN of S3 bucket used as CF Origin"
  
}

variable "s3_cf_origin_id" {
    type = string
    description = "ID of S3 bucket used as CF Origin"
  
}

variable "prod_account_id" {
    type        = string
    description = "ID of Prod Account"
  
}