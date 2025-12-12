
#Secret Manager for storing private key of ec2 instance key pair 
resource "aws_secretsmanager_secret" "ec2_private_key" {
  name        = "ec2-ssh-private-key"
  description = "Private SSH key for EC2 access"

  tags = {
    Environment = "PROD"
  }
}


resource "aws_secretsmanager_secret" "db_username" {
  name        = "db/username"
  description = "Database master username"
#  kms_key_id  = aws_kms_key.secrets.arn
}

resource "aws_secretsmanager_secret_version" "db_username_value" {
  secret_id     = aws_secretsmanager_secret.db_username.id
  secret_string = var.db_username
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "db/password"
  description = "Database master password"
 # kms_key_id  = aws_kms_key.secrets.arn
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}



locals {
  secret_arns = {
    ec2_key = aws_secretsmanager_secret.ec2_private_key.arn
    db_username = aws_secretsmanager_secret.db_username.arn
    db_password = aws_secretsmanager_secret.db_password.arn
  }
}

resource "aws_secretsmanager_secret_policy" "ec2_secret_policy" {
  for_each = local.secret_arns
  secret_arn = each.value

#    secret_arn = aws_secretsmanager_secret.ec2_private_key.arn

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
            #"arn:aws:iam::${data.terraform_remote_state.management.outputs.prod_account_id}:role/${var.ec2_secrets_role_name}",
            "${var.ec2_secrets_role_arn}",
            "${var.image_builder_role_arn}"
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
              "${var.ec2_secrets_role_arn}"
            ]
          }
        }
      }
    ]
  })
}
