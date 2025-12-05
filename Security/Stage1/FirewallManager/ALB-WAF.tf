resource "aws_wafv2_web_acl" "alb_cf_header_acl" {
  name        = "alb-allow-cloudfront-secret"
  description = "Allow only CloudFront with correct secret header"
  scope       = "REGIONAL"    # important for ALB

  default_action {
    block {}
  }

  rule {
    name     = "allow-cloudfront-secret-header"
    priority = 1

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        # Match the secret value
        search_string = var.cf_alb_shared_secret

        # Header name MUST be lower-case in WAF
        field_to_match {
          single_header {
            name = "x-cloudfront-secret"
          }
        }

        positional_constraint = "EXACTLY"

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-cloudfront-secret-header"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "alb-cf-header-acl"
    sampled_requests_enabled   = true
  }
}

resource "aws_fms_policy" "waf_alb_policy" {
  delete_unused_fm_managed_resources = true
  exclude_resource_tags              = false
  name                               = "prod-alb-waf-protection"
  remediation_enabled                = true
  resource_type                      = "AWS::ElasticLoadBalancingV2::LoadBalancer"

  # Attach to all ALBs in Prod OU (example)
  include_map {
    account = [var.prod_account_id]  # e.g. "ou-xxxxx-yyyyyy"
  }

  resource_tags = { 
    Name = "APP-ALB"
  }
  

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type = "WAFV2"
      preProcessRuleGroups = []
      postProcessRuleGroups = []
      defaultAction = {
        type = "BLOCK"
      }
      overrideCustomerWebACLAssociation = false

      # <<< The key: reference your WAF ACL here
      webaclId = aws_wafv2_web_acl.alb_cf_header_acl.arn
    })
  }
}