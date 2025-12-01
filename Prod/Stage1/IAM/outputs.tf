output "ec2_secret_manager_role_name" {
  value = aws_iam_role.ec2_secrets_reader.name
  description = "Name of the EC2 Secret Manager Role"
}