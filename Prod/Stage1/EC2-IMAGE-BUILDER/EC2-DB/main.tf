#DATABASE IMAGE BUILDER PIPELINE
resource "aws_imagebuilder_image_pipeline" "db_ami_pipeline" {
  name      = "database-ami-pipeline"
  image_recipe_arn              = aws_imagebuilder_image_recipe.db_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.db_infra.arn


  status = "ENABLED"
}


resource "aws_imagebuilder_image" "db_image" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.db_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.db_infra.arn

  tags = {
    Name = "database-rhel9-ansible"
  }
}
