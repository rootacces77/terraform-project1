#WEBSERVER IMAGE BUILDER PIPELINE
resource "aws_imagebuilder_image_pipeline" "web_ami_pipeline" {
  name      = "webserver-ami-pipeline"
  image_recipe_arn              = aws_imagebuilder_image_recipe.web_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.web_infra.arn


  status = "ENABLED"
}


resource "aws_imagebuilder_image" "web_image" {
  image_recipe_arn                 = aws_imagebuilder_image_recipe.web_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.web_infra.arn

  tags = {
    Name = "webserver-rhel9-ansible"
  }
}


#DATABASE IMAGE BUILDER PIPELINE
resource "aws_imagebuilder_image_pipeline" "db_ami_pipeline" {
  name      = "database-ami-pipeline"
  image_recipe_arn              = aws_imagebuilder_image_recipe.db_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.db_infra.arn


  status = "ENABLED"
}



/*resource "null_resource" "run_imagebuilder_once_db" {
  triggers = {
    pipeline_arn = aws_imagebuilder_image_pipeline.db_ami_pipeline.arn
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws imagebuilder start-image-pipeline-execution \
        --image-pipeline-arn ${aws_imagebuilder_image_pipeline.db_ami_pipeline.arn}
    EOT
  }
} */