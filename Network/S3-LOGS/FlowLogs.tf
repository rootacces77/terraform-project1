module "s3_flow_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = var.flowlogs_s3_name # must be globally unique and lowercase

  # Encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
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
    Name        = "prod-flowlogs"
    Environment = "PROD"
    Terraform   = "true"
  }
}


resource "aws_s3_bucket_policy" "org_readonly" {
  bucket = module.s3_flow_logs.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       : "OrgListBucket",
        Effect    : "Allow",
        Principal : "*",
        Action    : "s3:ListBucket",
        Resource  : "${module.s3_flow_logs.s3_bucket_arn}"
        Condition : {
          StringEquals : {
            "aws:PrincipalOrgID" = local.org_id
          }
        }
      },
      {
        Sid       : "OrgReadObjects",
        Effect    : "Allow",
        Principal : "*",
        Action    : "s3:GetObject",
        Resource  : "${module.s3_flow_logs.s3_bucket_arn}",
        Condition : {
          StringEquals : {
            "aws:PrincipalOrgID" = local.org_id
          }
        }
      },
     {
        Sid: "AWSLogDeliveryWrite",
        Effect: "Allow",
        Principal: { Service: "delivery.logs.amazonaws.com" },
        Action: "s3:PutObject",
        Resource: "${module.s3_flow_logs.s3_bucket_arn}/AWSFlowLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition: {
          StringEquals: {
            "aws:SourceAccount": data.aws_caller_identity.current.account_id,
            "s3:x-amz-acl": "bucket-owner-full-control"
          },
          ArnLike: {
            "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        Sid: "AWSLogDeliveryAclCheck",
        Effect: "Allow",
        Principal: { Service: "delivery.logs.amazonaws.com" },
        Action: "s3:GetBucketAcl",
        Resource: module.s3_flow_logs.s3_bucket_arn,
        Condition: {
          StringEquals: { "aws:SourceAccount": data.aws_caller_identity.current.account_id },
          ArnLike:      { "aws:SourceArn": "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:*"}
        }
      }
    ]
  })
} 