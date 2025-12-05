resource "aws_cloudtrail" "org" {

  name                          = var.trail_name
  s3_bucket_name                = var.s3_cloudtrail_logs_id
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  enable_logging                = true

}
