output "ec2_pk_secret_id" {
  value = aws_secretsmanager_secret.ec2_private_key.id
  description = "ID of Secret Manager for EC2 private key"
}