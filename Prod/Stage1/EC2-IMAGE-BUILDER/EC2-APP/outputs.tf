output "ec2_app_ami_id" {
    value = tolist(tolist(aws_imagebuilder_image.web_image.output_resources)[0].amis)[0].image
    description = "AMI ID of an image created"
  
}

output "web_builder_role_arn" {
    value = aws_iam_role.builder_role.arn
    description = "ARN of web builder role"
  
}