output "ec2_db_dns" {
    value = aws_instance.db_from_ami.private_dns
    description = "DB EC2 private DNS "
}