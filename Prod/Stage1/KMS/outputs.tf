output "ec2_key_id" {
  value = tls_private_key.ec2_key.id
  description = "ID of ec2_key"
}
