output "s3_ec2_logs_origin_arn" {
  value = module.s3_ec2_logs.s3_bucket_arn
}


output "s3_ec2_logs_regional_domain_name" {
  value = module.s3_ec2_logs.s3_bucket_bucket_regional_domain_name
}