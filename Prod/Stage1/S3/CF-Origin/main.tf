#S3 BUCKET USED BY CLOUDFRONT ORIGIN.POLICY IS ATTACHED AT CLOUDFRONT MODULE
module "s3_cf_origin" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = var.ec2_bucket_name# must be globally unique and lowercase

  # Encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }

#Storage Class glacier-instant 
  lifecycle_rule = [
    {
      id      = "glacier-instant-transition"
      enabled = true

      transition = [
        {
          days          = 30
          storage_class = "GLACIER_IR" # Glacier Instant Retrieval
        }
      ]

      expiration = {
        days = 365
      }
    }
  ]

  force_destroy = true
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # Block public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true


  tags = {
    Name        = "prod-cf-origin"
    Environment = "PROD"
    Terraform   = "true"
  }
}


resource "aws_s3_object" "static_logo" {
  bucket = module.s3_cf_origin.s3_bucket_id
  key    = local.static_key

  source       =local.static_image_path
  etag         = filemd5(local.static_image_path)  # triggers update if file changes
  content_type = "image/png"

  server_side_encryption = "AES256"
  cache_control          = "public, max-age=31536000, immutable"

  
}