#CREATE KMS AND STORE PRIVATE KEY IN SECRET MANAGER
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_secretsmanager_secret_version" "ssh_private_key_value" {
  secret_id     = var.secret_manager_pk_id
  secret_string = tls_private_key.ec2_key.private_key_pem
}