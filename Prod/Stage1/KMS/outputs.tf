output "ec2_key_id" {
  value = aws_key_pair.ec2_key.id
  description = "ID of ec2_key"
}

output "ec2_key_name" {
  value = aws_key_pair.ec2_key.key_name
  description = "Name of ec2_key"
}