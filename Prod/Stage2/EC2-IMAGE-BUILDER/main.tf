module "ec2-app" {
    source = "./EC2-APP"

    image_builder_profile_name = var.image_builder_profile_name
  
} 

