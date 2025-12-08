variable "cloudtrail_bucket_name" {
    type        = string
    description = "Name of CloudTrail S3 Bucket"
    default     = "org-cloudtrail-logs-12345"
  

}

variable "config_bucket_name" {
    type        = string
    description = "Name of AWS Config S3 Bucket"
    default     = "aws-config-org-123241"
  
}

variable "org_id" {
    type        = string
    description = "Organization ID "
  
}

variable "management_account_id" {
    type        = string
    description = "Management Account ID"
  
}

variable "security_account_id" {
    type = string
    description = "Security Account ID"
  
}
