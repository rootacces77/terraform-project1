module "ec2-app" {
    source = "./EC2-APP"

    secret_reader_policy_arn = var.secret_reader_policy_arn
  
} 

/*
module "ec2-db" {
    source = "./EC2-DB"

    secret_reader_policy_arn = var.secret_reader_policy_arn
  
} */
#+OUTPUTS