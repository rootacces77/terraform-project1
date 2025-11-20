module "vpc_prod" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD-DB-VPC"
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
  #public_subnet_assign_ipv6_address_on_creation = true
  #private_subnet_assign_ipv6_address_on_creation = true
  #Allow ipv6 output traffic
  #create_egress_only_igw = true
  
  create_igw = false

  enable_vpn_gateway = false


#  public_subnet_tags = {
 # "Name" = "PROD-SBNT-PUB"
 # "Tier" = "Public"
#}

private_subnet_tags = {
  "Name" = "PROD-DB-SBNT-PRIV"
  "Tier" = "Private"
}


  tags = {
    Terraform = "true"
    Environment = "PROD"
  }
}

#ASDF
#ASD