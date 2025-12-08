output "ec2_db_ami_id" {
    value = aws_imagebuilder_image.db_image.output_resources[0].amis[*].image
    description = "AMI ID of an image created"
  
}