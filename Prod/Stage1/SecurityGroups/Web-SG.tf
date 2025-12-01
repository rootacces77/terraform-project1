resource "aws_security_group" "prod_app_web" {
  name        = "prod-app-web-sg"
  description = "WebServer SG in shared PROD APP VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_app_id

  ingress {
    description              = "HTTPS from ALB only"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    security_groups          = [aws_security_group.prod_app_alb.id] 
  }

  # Allow outgoing to anywhere (common default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PROD-APP-WEB-SG"
    Environment = "PROD"
  }
}