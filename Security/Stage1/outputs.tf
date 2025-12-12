output "s3_config_logs_name" {
    value       = module.s3.s3_config_logs_name
    description = "ID of CloudTrail S3 bucket"
  
}

output "aws_config_role_arn" {
  value = module.iam.aws_config_role_arn
  description = "ARN of AWS Config Role"
}