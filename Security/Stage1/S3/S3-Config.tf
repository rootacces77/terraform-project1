module "s3_config_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = var.config_bucket_name# must be globally unique and lowercase

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
    Name        = "sec-cloudtrail-origin"
    Environment = "SEC"
    Terraform   = "true"
  }
}


resource "aws_s3_bucket_policy" "config_org_policy" {
  bucket = module.s3_config_logs.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # 1) Allow ALL ORG ACCOUNTS to put AWS Config data
      {
        Sid      = "AWSConfigOrgWrite"
        Effect   = "Allow"
        Principal = "*"
        Action   = "s3:PutObject"
        Resource = "${module.s3_config_logs.s3_bucket_arn}/AWSLogs/*/Config/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = var.org_id
          }
        }
      },

      # 2) Allow AWS Config service to GetBucketAcl (required)
      {
        Sid    = "AWSConfigGetBucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = module.s3_config_logs.s3_bucket_arn
      },

      # 3) Allow AWS Config service to PutObject with proper ACL
      {
        Sid    = "AWSConfigServicePutObject"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${module.s3_config_logs.s3_bucket_arn}/AWSLogs/*/Config/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },

      # 4) Security account root has full access to the bucket
      {
        Sid    = "SecurityAccountFullAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.security_account_id}:root"
        }
        Action   = "s3:*"
        Resource = [
          module.s3_config_logs.s3_bucket_arn,
          "${module.s3_config_logs.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}