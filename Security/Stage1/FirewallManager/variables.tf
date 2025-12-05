variable "prod_account_id" {
  type = string
  description = "Prod account ID "
}

variable "cf_alb_shared_secret" {
    type = string
    description = "Shared Secret between WAF and CF"
    default = "test123"
}

