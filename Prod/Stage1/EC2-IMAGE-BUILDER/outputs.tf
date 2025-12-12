output "ec2_app_ami_id" {
    value = module.ec2-app.ec2_app_ami_id
    description = "AMI ID of an image created"
  
}



/*output "ec2_db_ami_id" {
    value = module.ec2-db.ec2_db_ami_id
    description = "AMI ID of an image created"
  
} */