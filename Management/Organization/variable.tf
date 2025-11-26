data "aws_organizations_organization" "organization" {}

locals {
    org_root_id = data.aws_organizations_organization.organization.roots[0].id
    org_id      = data.aws_organizations_organization.organization.id
}

locals {

  # Flatten to a simple list of maps (id, name, email, status)
  accounts = [
    for a in data.aws_organizations_organization.organization.accounts : {
      id     = a.id
      name   = a.name
      email  = a.email
      status = a.status
    }
  ]

  # Convenience map: name -> account ID
  accounts_by_name = {
    for a in local.accounts :
    a.name => a.id
  }

  # Lookup IDs by account name
  dev_account_id     = try(local.accounts_by_name["Dev"],              null)
  prod_account_id    = try(local.accounts_by_name["Prod"],             null)
  network_account_id = try(local.accounts_by_name["Network"], null)
  security_account_id = try(local.accounts_by_name["Security"], null)
}