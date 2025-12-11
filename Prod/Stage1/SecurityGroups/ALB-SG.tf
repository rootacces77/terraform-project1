resource "aws_security_group" "prod_app_alb" {
  name        = "prod-app-alb-sg"
  description = "ALB SG in shared PROD APP VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_app_id

  ingress {
    description = "HTTPS from CloudFront"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PROD-APP-ALB-SG"
    Environment = "PROD"
  }
}