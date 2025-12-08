output "cf_dns" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
    description = "DNS of CF"
  
}



output "cf_hosted_zone_id" {
    value = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    description = "CF hosted zone ID "
  
}