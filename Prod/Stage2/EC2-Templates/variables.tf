variable "app_ami_id" {
    type        = string
    description = "ID of AMI for APP EC2"
    default     = "ami-02eb6e18fed00a7b2"
}

variable "app_instance_type" {
    type        = string
    description = "Type of instance for APP EC2"
    default     = "t2.micro"
  
}

variable "ec2_key_name" {
  type        = string
  description = "Name of key for EC2 access"
}

variable "app_ec2_sg_id" {
    type        = string
    description = "ID of SG for APP EC2"
  
}

variable "app_ec2_profile_arn" {
  type        = string
  description = "ARN of EC2 profile for App"
}