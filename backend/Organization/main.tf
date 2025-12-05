/*resource "aws_organizations_organization" "organization" {
  feature_set = "ALL"
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
    aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
  ]
} */

# Child accounts (email must be unique)
resource "aws_organizations_account" "network" {
  name  = "Network"
  email = "project.practice77+network@gmail.com"
 # depends_on = [aws_organizations_organization.organization]
}

resource "aws_organizations_account" "security" {
  name  = "Security"
  email = "project.practice77+security@gmail.com"
 # depends_on = [aws_organizations_organization.organization]
}

/*resource "aws_organizations_account" "dev" {
  name  = "Dev"
  email = "project.practice77+dev@gmail.com"
 # depends_on = [aws_organizations_organization.organization]
}

resource "aws_organizations_account" "prod" {
  name  = "Prod"
  email = "project.practice+prod@gmail.com"
 # depends_on = [aws_organizations_organization.organization]
} */
