 #Who in the mgmt account is allowed to assume AdminRole in members?
resource "aws_iam_group" "admins" {
  provider = aws.management
  name     = "Admins"
}

# Policy: allow sts:AssumeRole into the AdminRole in each member account
data "aws_iam_policy_document" "assume_member_adminrole" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${local.dev_account_id}:role/AdminRole",
      "arn:aws:iam::${local.prod_account_id}:role/AdminRole",
      "arn:aws:iam::${local.network_account_id}:role/AdminRole",
    ]
  }
}

resource "aws_iam_policy" "assume_member_adminrole" {
  provider = aws.management
  name     = "AssumeMemberAdminRole"
  policy   = data.aws_iam_policy_document.assume_member_adminrole.json
}

resource "aws_iam_group_policy_attachment" "admins_can_assume" {
  provider   = aws.management
  group      = aws_iam_group.admins.name
  policy_arn = aws_iam_policy.assume_member_adminrole.arn
}




# Get the management account ID for the trust policy
data "aws_caller_identity" "management" {
  provider = aws.management
}

# --- DEV account role ---
data "aws_iam_policy_document" "dev_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.management.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dev_adminrole" {
  provider           = aws.dev
  name               = "AdminRole"
  assume_role_policy = data.aws_iam_policy_document.dev_trust.json
}

resource "aws_iam_role_policy_attachment" "dev_admin_attach" {
  provider   = aws.dev
  role       = aws_iam_role.dev_adminrole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- PROD account role ---
data "aws_iam_policy_document" "prod_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.management.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "prod_adminrole" {
  provider           = aws.prod
  name               = "AdminRole"
  assume_role_policy = data.aws_iam_policy_document.prod_trust.json
}

resource "aws_iam_role_policy_attachment" "prod_admin_attach" {
  provider   = aws.prod
  role       = aws_iam_role.prod_adminrole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- NETWORK account role ---
data "aws_iam_policy_document" "network_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.management.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "network_adminrole" {
  provider           = aws.network
  name               = "AdminRole"
  assume_role_policy = data.aws_iam_policy_document.network_trust.json
}

resource "aws_iam_role_policy_attachment" "network_admin_attach" {
  provider   = aws.network
  role       = aws_iam_role.network_adminrole.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}