#############################
# ALB
#############################
resource "aws_lb" "alb" {
  name               = "APP-ALB"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_sg_id]
  subnets            = var.alb_subnets
  enable_deletion_protection = false

  tags = {
    Name = "APP-ALB"
  }
}

#############################
# ALB Listener (HTTP 80)
#############################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}