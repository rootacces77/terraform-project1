/*data "aws_route53_zone" "main" {
  provider     = aws.mgmt_dns
  name         = data.terraform_remote_state.management.outputs.domain_name
  private_zone = false
} */

#CREATE AND VALIDATE CERTIFICATE THAT WILL BE USED BY ALB AND CF
resource "aws_acm_certificate" "prod_app" {
  domain_name       =  data.terraform_remote_state.management.outputs.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "PROD-CERT"
    Environment = "PROD"
  }
}



# CREATE DNS VALIDATION RECORD(S) IN MANAGEMENT USING ASSUMED ROLE
resource "aws_route53_record" "prod_app_validation" {
  provider = aws.mgmt_dns

  # Turn the set(domain_validation_options) into a map keyed by domain_name
  for_each = {
    for dvo in aws_acm_certificate.prod_app.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.terraform_remote_state.management.outputs.zone_id

  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# VALIDATE CERT
resource "aws_acm_certificate_validation" "prod_app" {
  certificate_arn = aws_acm_certificate.prod_app.arn

  validation_record_fqdns = [
    for r in aws_route53_record.prod_app_validation : r.fqdn
  ]
}
