resource "aws_route53_record" "root_to_cloudfront" {
  provider = aws.route53-role

  zone_id = var.r53_zone_id
  name    = "project-practice77.com"
  type    = "A"

  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_zone_id
    evaluate_target_health = false
  }
}

########################
# CNAME – www.project-practice77.com → project-practice77.com
########################

resource "aws_route53_record" "www_to_root" {
  provider = aws.route53-role

  zone_id = var.r53_zone_id
  name    = "www.project-practice77.com"
  type    = "CNAME"
  ttl     = 300

  records = [
    "project-practice77.com"
  ]
}