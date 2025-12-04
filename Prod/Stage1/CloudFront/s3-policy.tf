resource "aws_s3_bucket_policy" "s3_cf_origin_attach" {
  bucket = var.s3_cf_origin_id
  policy = data.aws_iam_policy_document.s3_cf_origin_policy.json
}

data "aws_iam_policy_document" "s3_cf_origin_policy" {
  # (Recommended) Deny any non-HTTPS access
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      var.s3_cf_origin_arn,
      "${var.s3_cf_origin_arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  # Allow Prod account to list the bucket
  statement {
    sid     = "AllowProdAccountListBucket"
    effect  = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.prod_account_id}:root"]
    }

    resources = [var.s3_cf_origin_arn]
  }

  # Allow Prod account to manage objects
  statement {
    sid     = "AllowProdAccountObjectRW"
    effect  = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.prod_account_id}:root"]
    }

    resources = ["${var.s3_cf_origin_arn}/*"]
  }

  # Allow CloudFront (OAC) to read objects ONLY from your distribution
  statement {
    sid     = "AllowCloudFrontServiceReadOnly"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = ["${var.s3_cf_origin_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }

    # Extra guardrail: only allow when the distribution is in your Prod account
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [var.prod_account_id]
    }
  }
}
