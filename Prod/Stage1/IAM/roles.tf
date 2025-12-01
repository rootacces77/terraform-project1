############################
# IAM Role for EC2 to read Secrets Manager
############################
resource "aws_iam_role" "ec2_secrets_reader" {
  name = "EC2SecretsReaderRole"

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

############################
# Attach AWS managed read-only Secrets Manager policy
############################
resource "aws_iam_role_policy_attachment" "ec2_secrets_reader_attach" {
  role       = aws_iam_role.ec2_secrets_reader.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadOnly"
}

resource "aws_iam_instance_profile" "ec2_secrets_reader_profile" {
  name = "EC2SecretsReaderInstanceProfile"
  role = aws_iam_role.ec2_secrets_reader.name
}