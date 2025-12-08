
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