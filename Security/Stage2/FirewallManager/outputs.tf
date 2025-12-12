output "alb_waf_arn" {
  value = aws_wafv2_web_acl.alb_cf_header_acl.arn
}

output "cf_waf_arn" {
  value = aws_wafv2_web_acl.cf_acl.arn
}