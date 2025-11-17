resource "aws_organizations_organization" "organization" {
  feature_set = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
}

# Child accounts (email must be unique)
resource "aws_organizations_account" "network_security" {
  name  = "Network-Security"
  email = "project.practice77+network-security@gmail.com"
  depends_on = [aws_organizations_organization.organization]
}

resource "aws_organizations_account" "dev" {
  name  = "Dev"
  email = "project.practice77+dev@gmail.com"
  depends_on = [aws_organizations_organization.organization]
}

resource "aws_organizations_account" "prod" {
  name  = "Prod"
  email = "project.practice+prod@gmail.com"
  depends_on = [aws_organizations_organization.organization]
}


resource "aws_iam_user" "terraform_admin" {
  name = "admin"
}

resource "aws_iam_user_policy_attachment" "admin" {
  user       = aws_iam_user.terraform_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
