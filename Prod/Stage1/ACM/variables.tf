locals {
  apex_domain = data.terraform_remote_state.management.outputs.domain_name
  www_domain  = "www.${local.apex_domain}"
}