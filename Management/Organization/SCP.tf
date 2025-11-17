resource "aws_organizations_policy" "deny_non_us_east_1" {
  name        = "DenyAllRegionsExceptUsEast1"
  description = "Deny actions outside us-east-1; exclude global services."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid    = "DenyOutsideUsEast1",
        Effect = "Deny",
        NotAction = [
          # Global / edge or special endpoints to exclude from region checks
          "a2c:*",                    # Account/alternate contacts (varies)
          "budgets:*",
          "ce:*",
          "cloudfront:*",
          "globalaccelerator:*",
          "iam:*",
          "organizations:*",
          "route53:*",
          "route53domains:*",
          "sso:*",
          "sso-directory:*",
          "support:*",
          "waf:*",
          "waf-regional:*",
          "wafv2:*",
          "shield:*",
          "health:*"
        ],
        Resource  = "*",
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" : "us-east-1"
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach_region_restriction" {
  policy_id = aws_organizations_policy.deny_non_us_east_1.id
  target_id = local.org_root_id
}








resource "aws_organizations_policy" "deny_root_user" {
  name        = "DenyRootUser"
  description = "Deny all actions when the principal is the account root user."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid      = "DenyRootUser",
        Effect   = "Deny",
        Action   = "*",
        Resource = "*",
        Condition = {
          StringLike = {
            "aws:PrincipalArn" : "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

# Attach to the Root OU (affects all member accounts)
resource "aws_organizations_policy_attachment" "attach_deny_root_user" {
  policy_id = aws_organizations_policy.deny_root_user.id
  target_id = local.org_root_id
}