
output "prod_cert_arn" {
  value = aws_acm_certificate.prod_app.arn
  description = "ARN of Certificate"
  }