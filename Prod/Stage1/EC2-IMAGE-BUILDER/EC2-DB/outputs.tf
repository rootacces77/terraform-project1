output "ec2_db_ami_id" {
    value = tolist(tolist(aws_imagebuilder_image.db_image.output_resources)[0].amis)[0].image
    description = "AMI ID of an image created"
  
}