output "app_ec2_profile_arn" {
  value       = aws_iam_instance_profile.ec2_app_profile.arn
  description = "EC2 Profile for App"
}

output "app_ec2_role_arn" {
  value = aws_iam_role.app_ec2_role.arn
  description = "ARN of APP EC2 Role"
  
}