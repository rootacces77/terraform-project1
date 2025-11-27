#WEBSERVER IMAGE BUILDER RECIPE
resource "aws_imagebuilder_component" "build_image" {
  name       = "build-image"
  platform   = "Linux"
  version    = "1.0.0"
  data       = file("${path.module}/components/image-builder.yml")
}


resource "aws_imagebuilder_image_recipe" "web_recipe" {
  name         = "webserver-ami"
  version      = "1.0.0"
  parent_image = data.aws_ami.rhel9.id

  component {
    component_arn = aws_imagebuilder_component.build_image
  }

}

data "aws_ami" "rhel9" {
  most_recent = true

  # Adjust owner to the correct one for RHEL in your account/Marketplace
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["RHEL-9*"]  # use the exact pattern you see in EC2 -> AMIs
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}