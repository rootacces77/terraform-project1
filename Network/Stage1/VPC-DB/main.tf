module "vpc_prod_db" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD-VPC-DB"
  cidr = "10.17.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c",]
  private_subnets = [
                "10.17.1.0/24","10.17.2.0/24","10.17.3.0/24"

    ]


  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false

  
  create_igw = false

  enable_vpn_gateway = false


private_subnet_tags = {
  "Name" = "PROD-DB-SBNT-PRIV"
  "Tier" = "Private"
}


  tags = {
    Terraform = "true"
    Environment = "PROD"
  }
}


#FLOWLOGS
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = var.flowlogs_s3_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc_prod_db.vpc_id
}