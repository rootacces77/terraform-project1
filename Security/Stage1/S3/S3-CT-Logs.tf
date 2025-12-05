module "s3_cloudtrail_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = var.cloudtrail_bucket_name# must be globally unique and lowercase

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
    Name        = "prod-cloudtrail-origin"
    Environment = "PROD"
    Terraform   = "true"
  }
}


data "aws_iam_policy_document" "cloudtrail_bucket" {

  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [module.s3_cloudtrail_logs.s3_bucket_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.management_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:*:${var.management_account_id}:trail/*"]
    }
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = [
      "${module.s3_cloudtrail_logs.s3_bucket_arn}/AWSLogs/*",
    ]

    # CloudTrail requires this ACL for central log buckets
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.management_account_id]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:*:${var.management_account_id}:trail/*"]
    }
  }
  # List the bucket and get objects
  statement {
    sid = "OrgBucket"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["s3:ListBucket",
                 "s3:GetObject"]
    resources = [module.s3_cloudtrail_logs.s3_bucket_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket   = module.s3_cloudtrail_logs.s3_bucket_id
  policy   = data.aws_iam_policy_document.cloudtrail_bucket.json
}