output "alb_waf_arn" {
  value = module.firewall_manager.alb_waf_arn
}

output "cf_waf_arn" {
  value = module.firewall_manager.cf_waf_arn
}