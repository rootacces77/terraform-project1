#IMAGE BUILDER ROLE/PROFILE
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

resource "aws_iam_role_policy_attachment" "builder_secret_reader" {
  role       = aws_iam_role.builder_role.name
  policy_arn = aws_iam_policy.ec2_secrets_reader.arn
}

resource "aws_iam_instance_profile" "builder_profile" {
  name = "EC2ImageBuilderInstanceProfile"
  role = aws_iam_role.builder_role.name
}