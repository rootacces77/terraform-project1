variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
    default = "t2.micro"
  
}

variable "key_name" {
    type = string
    description = "EC2 Key Name"
  
}

variable "instance_profile_name" {
    type = string
    description = "Instance Profile Name"
  
}

variable "security_group_id" {
    type = string
    description = "Security Group ID"
  
}

variable "db_ami_id" {
    type = string
    description = "AMI ID for EC2 DB"
    default = "ami-0ac5f62b70a0beaac"
  
}

variable "subnet_id" {
    type = string
    description = "Subnet ID"
  
}
