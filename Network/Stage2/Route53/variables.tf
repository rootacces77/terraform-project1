variable "network_account_id" {
    type = string
    description = "Network Account ID"
  
}

variable "r53_zone_id" {
    type = string
    description = "Public hosted zone ID"
  
}

variable "cf_domain_name" {
    type = string
    description = "CF Domain Name"
  
}

variable "cf_zone_id" {
    type = string
    description = "CF Zone ID"
  
}

variable "prod_app_vpc_id" {
    type = string
    description = "Prod APP VPC ID"
  
}

variable "ec2_db_dns" {
    type = string
    description = "DNS of DB EC2"
  
}

variable "network_route53_role_arn" {
    type = string
    description = "Route53 Role ARN"
  
}
