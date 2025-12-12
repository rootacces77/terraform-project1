output "app_ec2_profile_arn" {
  value       = aws_iam_instance_profile.ec2_app_profile.arn
  description = "EC2 Profile for App"
}

output "app_ec2_profile_name" {
  value       = aws_iam_instance_profile.ec2_app_profile.name
  description = "EC2 Profile name for App"
}

output "app_ec2_role_arn" {
  value = aws_iam_role.app_ec2_role.arn
  description = "ARN of APP EC2 Role"
  
}

output "image_builder_profile_name" {
  value       = aws_iam_instance_profile.builder_profile.name
  description = "EC2 Profile name for building images"
}

output "image_builder_role_arn" {
  value = aws_iam_role.builder_role.arn
  description = "ARN of image builder role"
  
}