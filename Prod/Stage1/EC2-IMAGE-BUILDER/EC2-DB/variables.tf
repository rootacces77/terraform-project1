
variable "ec2_instance_type" {
  type = string
  description = "EC2 Instance Type for Database Image"
  default = "t2.micro"
}

variable "image_builder_profile_name" {
    type = string
    description = "Name of the profile for building images"
  
}