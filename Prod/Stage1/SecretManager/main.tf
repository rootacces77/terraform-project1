

resource "aws_secretsmanager_secret" "ec2_private_key" {
  name        = "ec2-ssh-private-key"
  description = "Private SSH key for EC2 access"

  tags = {
    Environment = "PROD"
  }
}

locals {
  secret_arns = [
    aws_secretsmanager_secret.ec2_private_key.arn
  ]
}

resource "aws_secretsmanager_secret_policy" "ec2_secret_policy" {
 # for_each = toset(local.secret_arns)
 # secret_arn = each.value

    secret_arn = aws_secretsmanager_secret.ec2_private_key.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow AdminAccess role and EC2 secrets role to read the secret
      {
        Sid    = "AllowAdminAndEc2RolesReadSecret",
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${data.terraform_remote_state.management.outputs.prod_account_id}:role/${var.admin_role_name}",
            "arn:aws:iam::${data.terraform_remote_state.management.outputs.prod_account_id}:role/${var.ec2_secrets_role_name}",
          ]
        },
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      },

      # Explicitly deny everyone else from reading the secret
      {
        Sid    = "DenyOthersReadingSecret",
        Effect = "Deny",
        Principal = "*",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*",
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::${data.terraform_remote_state.management.outputs.prod_account_id}:role/${var.admin_role_name}",
              "arn:aws:iam::${data.terraform_remote_state.management.outputs.prod_account_id}:role/${var.ec2_secrets_role_name}",
            ]
          }
        }
      }
    ]
  })
}
