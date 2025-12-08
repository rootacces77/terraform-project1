resource "aws_route53_zone" "project_practice_private" {
  provider = aws.route53-role

  name       = "project-practice77.com"

  # Associate with PROD VPC
  vpc {
    vpc_id = var.prod_app_vpc_id
  }

  comment = "Private hosted zone for project-practice77.com"

  tags = {
    Name        = "project-practice77.com-private"
    Environment = "PROD"
    Terraform   = "true"
  }
}

########################
# database.project-practice77.com → EC2 DNS
########################

resource "aws_route53_record" "database_db_private" {
  provider = aws.route53-role

  zone_id = aws_route53_zone.project_practice_private.zone_id
  name    = "database.project-practice77.com"
  type    = "CNAME"
  ttl     = 60

  # Use the EC2 instance DNS name
  records = [var.ec2_db_dns]
}

