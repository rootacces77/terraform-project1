resource "aws_security_group" "prod_app_db" {
  name        = "prod-app-db-sg"
  description = "DataBase SG in shared PROD APP VPC"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_db_id

  ingress {
    description              = "Allow Traffic From WebServer"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    security_groups          = [aws_security_group.prod_app_web.id] 
  }

  tags = {
    Name        = "PROD-APP-DB-SG"
    Environment = "PROD"
  }
}