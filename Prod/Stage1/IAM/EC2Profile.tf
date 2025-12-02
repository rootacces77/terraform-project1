############################
# IAM Role for EC2 APP 
############################
resource "aws_iam_role" "app_ec2_role" {
  name = "EC2APPRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AWS managed read-only Secrets Manager policy
data "aws_iam_policy_document" "ec2_secrets_reader" {
  statement {
    sid    = "ReadSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets"
    ]

    resources = ["*"] # or restrict to specific secret ARNs
  }

  # If your secrets use a customer-managed KMS key:
  statement {
    sid    = "DecryptKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt"
    ]

    resources = ["*"] # or your specific KMS key ARN
  }
}

resource "aws_iam_policy" "ec2_secrets_reader" {
  name   = "EC2SecretsReaderPolicy"
  policy = data.aws_iam_policy_document.ec2_secrets_reader.json
}
resource "aws_iam_role_policy_attachment" "ec2_secrets_reader_attach" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = aws_iam_policy.ec2_secrets_reader.arn
}

#SSM POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.app_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2_app_profile" {
  name = "AppEC2Profile"
  role = aws_iam_role.app_ec2_role.name
}