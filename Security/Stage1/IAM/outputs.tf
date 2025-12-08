output "aws_config_role_arn" {
  value = aws_iam_role.aws_config_role.arn
  description = "ARN of AWS Config Role"
}