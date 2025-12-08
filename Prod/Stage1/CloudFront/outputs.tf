output "cf_dns" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
    description = "DNS of CF"
  
}