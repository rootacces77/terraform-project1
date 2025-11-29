variable "app_private_rt_id" {
  type        = string
  description = "ID of VPC APP Private Subnets Route Table"
}

variable "db_private_rt_id" {
  type        = string
  description = "ID of VPC DB Private Subnets Route Table"
}

variable "vpc_app_cidr" {
  type        = string
  description = "CIDR of VPC APP"
}

variable "vpc_db_cidr" {
  type        = string
  description = "CIDR of VPC DB"
}

variable "vpc_peering_id" {
  type = string
  description = "Peering ID between VPC APP and VPC DB"
}