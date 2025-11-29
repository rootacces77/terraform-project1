/*module "vpc_prod_db" {
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
} */

########################
# VPC
########################
resource "aws_vpc" "vpc_prod_db" {
  cidr_block           = "10.17.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "PROD-VPC-DB"
    Terraform   = "true"
    Environment = "PROD"
  }
}

########################
# Private subnets (3x)
########################
locals {
  prod_db_private_subnets = {
    "us-east-1a" = "10.17.0.0/20"
    "us-east-1b" = "10.17.16.0/20"
    "us-east-1c" = "10.17.32.0/20"
  }
}

resource "aws_subnet" "prod_db_private" {
  for_each = local.prod_db_private_subnets

  vpc_id                  = aws_vpc.vpc_prod_db.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "PROD-DB-SBNT-PRIV"
    Tier        = "Private"
    Terraform   = "true"
    Environment = "PROD"
  }
}

########################
# Single private route table
########################
resource "aws_route_table" "prod_db_private" {
  vpc_id = aws_vpc.vpc_prod_db.id

  # No IGW/NAT → only implicit local route is needed

  tags = {
    Name        = "PROD-DB-PRIVATE-RT"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_route_table_association" "prod_db_private" {
  for_each       = aws_subnet.prod_db_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.prod_db_private.id
}

#FLOWLOGS
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = var.flowlogs_s3_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc_prod_db.id
}