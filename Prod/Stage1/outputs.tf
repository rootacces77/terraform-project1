
output "cf_dns" {
    value = module.cloudfront.cf_dns
    description = "DNS OF CF "
  
}

output "cf_hosted_zone_id" {
    value = module.cloudfront.cf_hosted_zone_id
    description = "CF hosted zone ID "
  
}


output "ec2_db_dns" {
    value = module.ec2-db.ec2_db_dns
    description = "DB EC2 private DNS "
} 


output "target_group_id" {
    value = module.alb.target_group_id
    description = "TargetGroup"
  
}

output "app_ec2_profile_arn" {
  value       = module.iam.app_ec2_profile_arn
  description = "EC2 Profile for App"
}

output "ec2_key_name" {
  value = module.kms.ec2_key_name
  description = "Name of ec2_key"
}

output "web_sg_id" {
    value       = module.security_groups.web_sg_id
    description = "ID of Web Server Security Group"
}

output "image_builder_profile_name" {
  value       = module.iam.image_builder_profile_name
  description = "EC2 Profile name for building images"
}

