output "org_id" {
  value = module.organization.org_id
  description = "Organization ID for policies"
}

output "security_account_id" {
  value = module.organization.security_account_id
  description = "Security Account ID"
}


output "prod_account_id" {
  value = module.organization.prod_account_id
  description = "Prod Account ID"
}

output "network_account_id" {
  value = module.organization.network_account_id
  description = "Network Account ID"
}


output "prod_route53_role_arn" {
  value = module.organization.prod_route53_role_arn
  description = "ARN of role to allow Route53 certifications validation"
}

output "domain_name" {
  value = var.domain_name
  description = "Registered Domain Name"
  }

  output "domain_zone_id" {
  value = data.aws_route53_zone.main.zone_id
  description = "Domain Zone ID"
  }