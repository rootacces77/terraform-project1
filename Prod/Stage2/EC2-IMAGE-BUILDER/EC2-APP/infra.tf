resource "aws_imagebuilder_infrastructure_configuration" "web_infra" {
  name                  = "webserver-infra"
  instance_types        = [var.ec2_instance_type]
  terminate_instance_on_failure = true
  instance_profile_name       = var.image_builder_profile_name
}
