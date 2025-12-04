output "s3_cf_origin_arn" {
  value = module.cf-origin.s3_cf_origin_arn
}

output "s3_cf_origin_id" {
  value = module.cf-origin.s3_cf_origin_id
}

output "s3_cf_origin_regional_domain_name" {
  value = module.cf-origin.s3_cf_origin_regional_domain_name
}

output "s3_ec2_logs_arn" {
  value = module.ec2_logs.s3_ec2_logs_origin_arn
}

output "s3_ec2_logs_regional_domain_name" {
  value = module.ec2_logs.s3_ec2_logs_regional_domain_name
}