
data "aws_ami" "rhel9" {
  most_recent = true

  owners = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-9.*_HVM-*-x86_64-*-Hourly2-GP*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
}

#WEBSERVER IMAGE BUILDER RECIPE
resource "aws_imagebuilder_component" "web_build_image" {
  name       = "build-image"
  platform   = "Linux"
  version    = "1.0.0"
  data       = file("${path.module}/components/web-image-builder.yaml")
}


resource "aws_imagebuilder_image_recipe" "web_recipe" {
  name         = "webserver-ami"
  version      = "1.0.0"
  parent_image = data.aws_ami.rhel9.id

  component {
    component_arn = aws_imagebuilder_component.web_build_image.arn
  }

}



#DATABASE IMAGE BUILDER RECIPE
resource "aws_imagebuilder_component" "db_build_image" {
  name       = "build-image"
  platform   = "Linux"
  version    = "1.0.0"
  data       = file("${path.module}/components/db-image-builder.yaml")
}


resource "aws_imagebuilder_image_recipe" "db_recipe" {
  name         = "database-ami"
  version      = "1.0.0"
  parent_image = data.aws_ami.rhel9.id

  component {
    component_arn = aws_imagebuilder_component.db_build_image.arn
  }

}
