output "alb_sg_id" {
    value       = aws_security_group.prod_app_alb.id
    description = "ID of ALB Security Group"
}

output "web_sg_id" {
    value       = aws_security_group.prod_app_web.id
    description = "ID of Web Server Security Group"
}

output "db_sg_id" {
    value       = aws_security_group.prod_app_db.id
    description = "ID of Database Server Security Group"
}