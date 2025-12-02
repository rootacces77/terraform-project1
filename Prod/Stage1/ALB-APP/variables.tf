
variable "tg_port" {
  type = string
  description = "Target Group Port"
  default = "80"
}

variable "target_type" {
  description = "Target type (instance, ip, lambda)"
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "alb_sg_id" {
  type = string
  description = "ALB Security Group ID"
}

variable "acm_certificate_arn" {
    type = string
    description = "ARN of ACM Certificate"
  
}

variable "alb_subnets" {
  type = list(string)
  description = "List of subnet ID's"
  
}