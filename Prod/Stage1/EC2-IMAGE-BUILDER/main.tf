module "ec2-app" {
    source = "./EC2-APP"

    image_builder_profile_name = var.image_builder_profile_name
  
} 

/*
module "ec2-db" {
    source = "./EC2-DB"

    secret_reader_policy_arn = var.secret_reader_policy_arn
  
} */
#+OUTPUTS