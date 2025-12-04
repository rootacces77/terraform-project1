
############################
# CloudWatch Logs (from EC2)
############################
resource "aws_cloudwatch_log_group" "ec2" {
  name              = var.ec2_log_group_name
  retention_in_days = var.log_retention_days
  kms_key_id        = var.cloudwatch_logs_kms_key_arn # optional; may be null
  tags              = var.tags
}

######################################
# Firehose -> S3 (destination delivery)
######################################
resource "aws_iam_role" "firehose_to_s3" {
  name = "${var.name_prefix}-firehose-to-s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "firehose.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "firehose_to_s3" {
  name = "${var.name_prefix}-firehose-to-s3-policy"
  role = aws_iam_role.firehose_to_s3.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Write objects into S3
      {
        Effect = "Allow",
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Resource = [
          var.logs_bucket_arn,
          "${var.logs_bucket_arn}/*"
        ]
      },
      # Firehose delivery logging (optional but recommended)
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      # If you enable SSE-KMS on delivery stream / bucket, add KMS permissions here.
      # {
      #   Effect = "Allow",
      #   Action = ["kms:Decrypt","kms:Encrypt","kms:GenerateDataKey","kms:DescribeKey"],
      #   Resource = var.s3_kms_key_arn
      # }
    ]
  })
}

resource "aws_kinesis_firehose_delivery_stream" "ec2_logs_to_s3" {
  name        = "${var.name_prefix}-ec2-logs-to-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_to_s3.arn
    bucket_arn = var.logs_bucket_arn

    prefix              = var.s3_prefix
    error_output_prefix = "${var.s3_prefix}errors/"

    buffering_size     = 5
    buffering_interval = 300
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose.name
      log_stream_name = "S3Delivery"
    }
  }

  tags = var.tags
}

# Firehose delivery stream’s own logs
resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/kinesisfirehose/${var.name_prefix}-ec2-logs-to-s3"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# Common race: subscription filter can fail if Firehose isn't ACTIVE yet.
resource "time_sleep" "wait_for_firehose" {
  depends_on      = [aws_kinesis_firehose_delivery_stream.ec2_logs_to_s3]
  create_duration = "30s"
}

#################################################
# CloudWatch Logs -> Firehose (subscription filter)
#################################################
resource "aws_iam_role" "cwl_to_firehose" {
  name = "${var.name_prefix}-cwl-to-firehose"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "logs.${var.aws_region_id}.amazonaws.com" },
      Action = "sts:AssumeRole",
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = var.prod_account_id
        }
      }
    }]
  })    

  tags = var.tags
}

resource "aws_iam_role_policy" "cwl_to_firehose" {
  name = "${var.name_prefix}-cwl-to-firehose-policy"
  role = aws_iam_role.cwl_to_firehose.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "firehose:PutRecord",
        "firehose:PutRecordBatch"
      ],
      Resource = aws_kinesis_firehose_delivery_stream.ec2_logs_to_s3.arn
    }]
  })
}

resource "aws_cloudwatch_log_subscription_filter" "all_to_s3" {
  name            = "${var.name_prefix}-all-to-s3"
  log_group_name  = aws_cloudwatch_log_group.ec2.name
  filter_pattern  = "" # empty = match everything
  destination_arn = aws_kinesis_firehose_delivery_stream.ec2_logs_to_s3.arn
  role_arn        = aws_iam_role.cwl_to_firehose.arn

  depends_on = [time_sleep.wait_for_firehose]
}
