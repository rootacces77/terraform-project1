output "s3_cf_origin_arn" {
  value = module.s3_cf_origin.s3_bucket_arn
}

output "s3_cf_origin_id" {
  value = module.s3_cf_origin.s3_bucket_id
}

output "s3_cf_origin_regional_domain_name" {
  value = module.s3_cf_origin.s3_bucket_bucket_regional_domain_name
}