
variable "trail_name" {
    type = string
    description = "Name of CloudTrail trail"
    default = "ORG_Trail"
  
}

variable "s3_cloudtrail_logs_id" {
    type = string
    description = "ID of S3 bucket used by CloudTrail"
  
}