resource "aws_securityhub_account" "main" {}

#Subscribe to AWS Foundational Security Best Practices
resource "aws_securityhub_standards_subscription" "fsbp" {
  standards_arn = "arn:aws:securityhub:us-east-1::standards/aws-foundational-security-best-practices/v/1.0.0"
}