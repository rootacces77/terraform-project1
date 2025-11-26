module "vpc_prod_app" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD-VPC-APP"
  cidr = "10.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c",]
  private_subnets = [
                "10.16.0.0/20","10.16.64.0/20","10.16.128.0/20",
                "10.16.16.0/20","10.16.80.0/20","10.16.144.0/20",
                "10.16.32.0/20","10.16.96.0/20","10.16.160.0/20"

    ]
  public_subnets  = ["10.16.48.0/20","10.16.112.0/20","10.16.176.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false
  create_egress_only_igw = false
  
  create_igw = true

  enable_vpn_gateway = false


  public_subnet_tags = {
  "Name" = "PROD-APP-SBNT-PUB"
  "Tier" = "Public"
}

private_subnet_tags = {
  "Name" = "PROD-APP-SBNT-PRIV"
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
  vpc_id               = module.vpc_prod_app.vpc_id
}