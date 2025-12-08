output "ec2_app_ami_id" {
    value = aws_imagebuilder_image.web_image.output_resources[0].amis[*].image
    description = "AMI ID of an image created"
  
}