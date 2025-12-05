#Enable RAM Sharing within organization
resource "aws_ram_sharing_with_organization" "enable" {
#  enabled = true
}

resource "aws_cloudtrail_organization_delegated_admin_account" "security" {
  provider   = aws.management
  account_id = local.security_account_id

}