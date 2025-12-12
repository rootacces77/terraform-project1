#DATABASE IMAGE BUILDER INFRA

resource "aws_imagebuilder_infrastructure_configuration" "db_infra" {
  name                  = "database-infra"
  instance_types        = ["t2.micro"]
  terminate_instance_on_failure = true
  instance_profile_name       = var.image_builder_profile_name
}