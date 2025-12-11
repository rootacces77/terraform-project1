
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

output "app_ec2_template_id" {
    value       = module.ec2_templates.app_ec2_template_id
    description = "ID of APP Template"
}

output "target_group_id" {
    value = module.alb.target_group_id
    description = "TargetGroup"
  
}