variable "ec2_bucket_name" {
  type        = string
  description = "Name of the bucket for storing EC2 logs"
  default     = "cf-origin-prod-us-east-1-123456"
}

variable "prod_account_id" {
    type        = string
    description = "ID of Prod Account"
    
  
}

/*variable "static_image_path" {
  type        = string
  default     = "${path.module}/s3-cf-origin-data/logo.png"
  description = "Local path to the image file to upload"
}*/

locals {
  static_key = "static/logo.png"
  static_image_path = "${path.module}/s3-cf-origin-data/logo.png"
}
