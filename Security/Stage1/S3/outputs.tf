output "s3_cloudtrail_logs_id" {
    value       = module.s3_cloudtrail_logs.s3_bucket_id
    description = "ID of CloudTrail S3 bucket"
  
}

output "s3_config_logs_arn" {
    value       = module.s3_config_logs.s3_bucket_arn
    description = "ID of CloudTrail S3 bucket"
  
}

output "s3_config_logs_name" {
    value       = module.s3_config_logs.s3_bucket_id
    description = "ID of CloudTrail S3 bucket"
  
}