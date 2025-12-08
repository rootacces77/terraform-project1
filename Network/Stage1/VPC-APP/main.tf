/*module "vpc_prod_app" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "PROD-VPC-APP"
  cidr = "10.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c",]
    #Security Subnets
  intra_subnets = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]

  private_subnets = [
 #               "10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20",
                "10.16.48.0/20","10.16.64.0/20","10.16.80.0/20",
                "10.16.96.0/20","10.16.112.0/20","10.16.128.0/20"
                ]
  public_subnets  = ["10.16.144.0/20","10.16.160.0/20","10.16.176.0/20"]

  enable_nat_gateway = false
  single_nat_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false
  create_egress_only_igw = false
  
  create_igw = true

  enable_vpn_gateway = false
  #subnet_create_before_destroy = false


  intra_subnet_tags = {
    Name = "PROD-APP-SBNT-SEC"
    Tier = "Firewall"
  }

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
} */

resource "aws_vpc" "vpc_prod_app" {
  cidr_block           = "10.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "PROD-VPC-APP"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_internet_gateway" "prod_app_igw" {
  vpc_id = aws_vpc.vpc_prod_app.id

  tags = {
    Name        = "PROD-APP-IGW"
    Terraform   = "true"
    Environment = "PROD"
  }
}

########################
# SUBNETS CIDR
########################
locals {
  prod_app_public_subnets = {
    "us-east-1a" = "10.16.0.0/20"
    "us-east-1b" = "10.16.16.0/20"
    "us-east-1c" = "10.16.32.0/20"
  }
  prod_app_security_subnets = {
    "us-east-1a" = "10.16.48.0/20"
    "us-east-1b" = "10.16.64.0/20"
    "us-east-1c" = "10.16.80.0/20"
  }
  prod_app_private_subnets = {
    "us-east-1a" = "10.16.96.0/20"
    "us-east-1b" = "10.16.112.0/20"
    "us-east-1c" = "10.16.128.0/20"
  }
}

########################
# PUBLIC SUBNETS
########################

resource "aws_subnet" "prod_app_public" {
  for_each = local.prod_app_public_subnets

  vpc_id                  = aws_vpc.vpc_prod_app.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "PROD-APP-SBNT-PUBLIC"
    Tier        = "PUBLIC"
    Terraform   = "true"
    Environment = "PROD"
  }
}

#NAT

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.prod_app_public[0].id

  tags = {
    Name = "nat-gw-public-1"
  }
}



#RT
resource "aws_route_table" "prod_app_public" {
  vpc_id = aws_vpc.vpc_prod_app.id

  tags = {
    Name        = "PROD-APP-PUBLIC-RT"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_route_table_association" "prod_app_public" {
  for_each       = aws_subnet.prod_app_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.prod_app_public.id
}

resource "aws_route" "prod_app_public_igw_route" {
  route_table_id         = aws_route_table.prod_app_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod_app_igw.id
}

########################
# SECURITY SUBNETS
########################

resource "aws_subnet" "prod_app_security" {
  for_each = local.prod_app_security_subnets

  vpc_id                  = aws_vpc.vpc_prod_app.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "PROD-APP-SBNT-SECURITY"
    Tier        = "SECURITY"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_route_table" "prod_app_security" {
  vpc_id = aws_vpc.vpc_prod_app.id

  tags = {
    Name        = "PROD-APP-SECURITY-RT"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_route_table_association" "prod_app_security" {
  for_each       = aws_subnet.prod_app_security
  subnet_id      = each.value.id
  route_table_id = aws_route_table.prod_app_security.id
}
/*
resource "aws_route" "firewall_to_nat" {
  route_table_id         = aws_route_table.firewall_subnets.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = 
} */


########################
# PRIVATE SUBNETS
########################

resource "aws_subnet" "prod_app_private" {
  for_each = local.prod_app_private_subnets

  vpc_id                  = aws_vpc.vpc_prod_app.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "PROD-APP-SBNT-PRIVATE"
    Tier        = "PRIVATE"
    Terraform   = "true"
    Environment = "PROD"
  }
}

resource "aws_route_table" "prod_app_private" {
  vpc_id = aws_vpc.vpc_prod_app.id

  tags = {
    Name        = "PROD-APP-PRIVATE-RT"
    Terraform   = "true"
    Environment = "PROD"
  }
}


resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.prod_app_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "prod_app_private" {
  for_each       = aws_subnet.prod_app_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.prod_app_private.id
}






#FLOWLOGS
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = var.flowlogs_s3_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc_prod_app.id
}