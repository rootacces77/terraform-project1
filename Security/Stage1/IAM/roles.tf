resource "aws_iam_role" "aws_config_role" {
  name = "AWSConfigRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "aws_config_role_policy" {
  name = "AWSConfigRolePolicy"
  role = aws_iam_role.aws_config_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowAWSConfigToWriteToS3",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ],
        Resource = [
          "${var.s3_config_arn}",
          "${var.s3_config_arn}/*"
        ]
      },
      {
        Sid    = "AllowAWSConfigToPublishToSNS",
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowAWSConfigToDescribeAndList",
        Effect = "Allow",
        Action = [
          "ec2:*",
          "rds:*",
          "s3:*",
          "iam:*",
          "cloudtrail:*",
          "lambda:*",
          "organizations:DescribeOrganization",
          "organizations:ListAccounts",
          "organizations:ListOrganizationalUnitsForParent",
          "organizations:ListParents",
          "organizations:ListChildren"
        ],
        Resource = "*"
      }
    ]
  })
}