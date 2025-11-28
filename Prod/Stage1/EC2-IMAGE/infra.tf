#WEBSERVER IMAGE BUILDER INFRA
data "aws_iam_policy_document" "builder_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "imagebuilder.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "builder_role" {
  name               = "EC2ImageBuilderRole"
  assume_role_policy = data.aws_iam_policy_document.builder_assume_role.json
}

resource "aws_iam_role_policy_attachment" "builder_attach" {
  role       = aws_iam_role.builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

resource "aws_iam_role_policy_attachment" "builder_ssm_core" {
  role       = aws_iam_role.builder_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "builder_profile" {
  name = "EC2ImageBuilderInstanceProfile"
  role = aws_iam_role.builder_role.name
}

resource "aws_imagebuilder_infrastructure_configuration" "web_infra" {
  name                  = "webserver-infra"
  instance_types        = ["t2.micro"]
  terminate_instance_on_failure = true
  instance_profile_name       = aws_iam_instance_profile.builder_profile.name
}


#DATABASE IMAGE BUILDER INFRA

resource "aws_imagebuilder_infrastructure_configuration" "db_infra" {
  name                  = "database-infra"
  instance_types        = ["t2.micro"]
  terminate_instance_on_failure = true
  instance_profile_name       = aws_iam_instance_profile.builder_profile.name
}
