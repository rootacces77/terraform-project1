/*module "ec2_logs" {
  source = "./EC2-Logs"

  aws_region_id    = var.aws_region_id
  org_id           = var.org_id
  prod_account_id = var.prod_account_id
} */

module "cf-origin" {
    source = "./CF-Origin"

    prod_account_id             = var.prod_account_id
  
}

