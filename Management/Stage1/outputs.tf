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
  value = module.organization.prod_account_id
  description = "Prod Account ID"
}