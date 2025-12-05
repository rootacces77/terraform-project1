#WAF ACL
resource "aws_wafv2_web_acl" "cf_acl" {
  name        = "cloudfront-default-protections"
  description = "Baseline + L7 DDoS protections for CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }



  # 0) Anti-DDoS managed rule group (L7 DDoS toggle)
  rule {
    name     = "AWSManagedRulesAntiDDoSRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAntiDDoSRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAntiDDoSRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 1) IP reputation
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  # 2) Known bad inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  # 3) Common rule set (OWASP-ish)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfront-default-plus-l7-ddos"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "cloudfront-default-protections-l7-ddos"
  }
}


#FIREWALL MANAGEr POLICY
resource "aws_fms_policy" "cloudfront_waf_policy" {
  name                               = "cloudfront-waf-protection"
  remediation_enabled                = true
  delete_unused_fm_managed_resources = true
  exclude_resource_tags              = false

  # 🔹 Where to apply – this is your include_map
  include_map {
    account = [var.prod_account_id]
    # or:
    # orgunit = [var.prod_ou_id]
  }

  # 🔹 This tells FMS we are managing CloudFront distributions
  resource_type = "AWS::CloudFront::Distribution"

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type              = "WAFV2"
      overrideCustomerWebACLAssociation = false

      # 🔹 Attach your CLOUDFRONT-scoped ACL
      webaclId          = aws_wafv2_web_acl.cf_acl.arn

      # must be present, even if empty:
      preProcessRuleGroups  = []
      postProcessRuleGroups = []

      defaultAction = {
        type = "ALLOW"
      }
    })
  }
}

