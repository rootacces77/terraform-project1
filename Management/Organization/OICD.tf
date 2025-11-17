# 1) OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Include both known intermediates to avoid chain flips
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

# 2) Role trusted by GitHub OIDC (branch-pinned)
data "aws_iam_policy_document" "gha_oidc_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    # Always check audience
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Lock to your repo + branch (edit ORG/REPO/BRANCH)
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:rootacces77/terraform-project1:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "gha_deploy" {
  name               = "GitHubActionsTerraformRole"
  assume_role_policy = data.aws_iam_policy_document.gha_oidc_assume.json
}

# Attach permissions you need (start narrow; Admin only for bootstrap/testing)
resource "aws_iam_role_policy_attachment" "gha_admin" {
  role       = aws_iam_role.gha_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


output "role_arn"          { value = aws_iam_role.gha_deploy.arn }