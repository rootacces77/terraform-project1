#WEBSERVER IMAGE BUILDER PIPELINE
resource "aws_imagebuilder_image_pipeline" "web_ami_pipeline" {
  name      = "webserver-ami-pipeline"
  image_recipe_arn              = aws_imagebuilder_image_recipe.web_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.web_infra.arn


  status = "ENABLED"
}