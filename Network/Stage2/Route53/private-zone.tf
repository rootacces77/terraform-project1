resource "aws_route53_zone" "project_practice_private" {
  name       = "project-practice.com"

  # Associate with PROD VPC
  vpc {
    vpc_id = var.prod_app_vpc_id
  }

  comment = "Private hosted zone for project-practice.com"

  tags = {
    Name        = "project-practice.com-private"
    Environment = "PROD"
    Terraform   = "true"
  }
}


resource "aws_route53_record" "database_db_private" {

  zone_id = aws_route53_zone.project_practice_private.zone_id
  name    = "database.project-practice.com"
  type    = "CNAME"
  ttl     = 60

  # Use the EC2 instance DNS name
  records = [var.ec2_db_dns]
}

