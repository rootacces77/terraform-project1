output "alb_dns_name" {
  value = aws_lb.alb.dns_name
  description = "DNS of ALB"
}

output "target_group_id" {
    value = aws_lb_target_group.tg.id
    description = "TargetGroup"
  
}