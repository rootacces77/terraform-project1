output "app_ec2_template_id" {
    value       = aws_launch_template.app_template.id
    description = "ID of APP Template"
}