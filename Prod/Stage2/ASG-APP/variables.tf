variable "app_private_subnet_ids" {
    type        = list(string)
    description = "Auto Scaling Group Subnets"
  
}

variable "asg_target_group_arn" {
  type        = string
  description = "Target Group ARN of ASG"
}

variable "app_template_id" {
  type        = string
  description = "ID of APP template"
}