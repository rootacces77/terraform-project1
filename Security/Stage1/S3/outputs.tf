output "s3_cloudtrail_logs_id" {
    value       = module.s3_cloudtrail_logs.s3_bucket_id
    description = "ID of CloudTrail S3 bucket"
  
}