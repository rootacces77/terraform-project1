module "vpc_prod" {
  source = "terraform-aws-modules/vpc/aws"

  name = "PROD-DB-VPC"
  cidr = "10.17.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c",]
  private_subnets = [
                "10.17.0.0/19","10.17.8.0/19","10.17.16.0/19"

    ]
  #public_subnets  = ["10.16.48.0/20","10.16.112.0/20","10.16.176.0/20"]

  #private_subnet_ipv6_prefixes  = [0, 4, 8,1,5,9,2,6,10]
  #public_subnet_ipv6_prefixes = [3, 7, 11]

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