resource "aws_iam_role" "prod_route53_writer" {
  name = "ProdRoute53Route53Writer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = [ "arn:aws:iam::${local.prod_account_id}:root",
                "arn:aws:iam::238407199949:role/GitHubActionsTerraformRole"
          

        ]
        # or better: a specific role in Prod you use for Terraform/CI
      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_route53_zone" "main" {
  name         = var.domain_name   # your domain
  private_zone = false
}

resource "aws_iam_policy" "prod_route53_writer" {
  name = "ProdRoute53WriterPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # Allow ACM validation CNAME only (_xxxx.example.com)
      {
        Sid    = "AllowOnlyACMValidationCNAME",
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:GetChange"
        ],
        Resource = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.main.zone_id}",
        Condition = {
          # Only allow CNAME changes
          "ForAllValues:StringEquals" = {
            "route53:ChangeResourceRecordSetsRecordTypes" = ["CNAME"]
          },
          # Only allow names that match ACM validation (_*.example.com)
          # Must be lowercased here
          "ForAllValues:StringLike" = {
            "route53:ChangeResourceRecordSetsNormalizedRecordNames" = [
              "_*.${var.domain_name}"   # <-- change domain here
            ]
          }
        }
      },

      # Allow minimal discovery/list of hosted zones
      {
        Sid    = "ListHostedZones",
        Effect = "Allow",
        Action = [
          "route53:ListHostedZonesByName",
          "route53:ListHostedZones",
          "route53:GetHostedZone",
          "route53:ListTagsForResource"
        ],
        Resource = "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "prod_route53_writer_attach" {
  role       = aws_iam_role.prod_route53_writer.name
  policy_arn = aws_iam_policy.prod_route53_writer.arn
}
