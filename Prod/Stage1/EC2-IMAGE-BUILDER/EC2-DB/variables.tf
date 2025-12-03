variable "secret_reader_policy_arn" {
  type = string
  description = "ARN of Secret Manager Reader Policy"
}

variable "ec2_instance_type" {
  type = string
  description = "EC2 Instance Type for Database Image"
  default = "t2.micro"
}