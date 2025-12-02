variable "domain_name" {
    type = string
    description = "Registered Domain Name"
    default = "project-practice.com"
  
}

data "aws_route53_zone" "main" {
  provider     = aws.management
  name         = var.domain_name
  private_zone = false
}
