data "aws_organizations_organization" "organization" {}
locals {
  org_root_id = data.aws_organizations_organization.organization.roots[0].id
}


data "external" "org_accounts" {
  program = [
    "bash", "-lc",
    <<-EOT
      set -euo pipefail
      # Ask AWS Organizations for all accounts (CLI returns full pagination)
      json=$(aws organizations list-accounts --output json)
      # Print as a single line for the external data source
      b64="$(printf "%s" "$json" | base64 | tr -d '\n')"   # portable base64, no newlines
      printf '{"accounts_b64":"%s"}' "$b64"
    EOT
  ]
}

locals {
  # Full parsed structure from AWS CLI
  accounts_raw = try(jsondecode(base64decode(data.external.org_accounts.result.accounts_b64)))

  # Flatten to a simpler list of maps
  accounts = try([
    for a in local.accounts_raw.Accounts : {
      id    = a.Id
      name  = a.Name
      email = a.Email
      status = a.Status
    }
  ], [])

  # Maps for convenient lookup
  accounts_by_name  = { for a in local.accounts : a.name  => a.id }

  # >>>> Adjust these names/emails to match exactly what you created <<<<
  dev_account_id      = try(local.accounts_by_name["Dev"],  null)
  prod_account_id     = try(local.accounts_by_name["Prod"], null)
  network_account_id  = try(local.accounts_by_name["Network-Security"], null)

}