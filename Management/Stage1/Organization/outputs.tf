output "org_id" {
  value = local.org_id
  description = "Organization ID for policies"
}
output "management_account_id" {
  value = local.management_account_id
  description = "Management Account ID"
}

output "security_account_id" {
  value = local.security_account_id
  description = "Security Account ID"
}

output "prod_account_id" {
  value = local.prod_account_id
  description = "Prod Account ID"
}

output "network_account_id" {
  value = local.network_account_id
  description = "Network Account ID"
}


output "prod_route53_role_arn" {
  value = aws_iam_role.prod_route53_writer.arn
  description = "ARN of role to allow Route53 certifications validation"
}

output "network_route53_role_arn" {
  value = aws_iam_role.route53_network.arn
  description = "ARN of Role for route53"
  
}