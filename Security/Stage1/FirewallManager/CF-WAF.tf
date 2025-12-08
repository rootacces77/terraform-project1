#WAF ACL
resource "aws_wafv2_web_acl" "cf_acl" {
  name        = "cloudfront-default-protections"
  description = "Baseline + L7 DDoS protections for CloudFront"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
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


/*
resource "aws_fms_policy" "cloudfront_waf_policy" {
  name                               = "cloudfront-waf-protection"
  remediation_enabled                = true
  delete_unused_fm_managed_resources = true
  exclude_resource_tags              = false

  # Where to apply
  include_map {
    account = [var.prod_account_id]
    # or:
    # orgunit = [var.prod_ou_id]
  }

  # Tell FMS we’re managing CloudFront distributions
  resource_type = "AWS::CloudFront::Distribution"

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type                              = "WAFV2"
      overrideCustomerWebACLAssociation = false

      #  PRE-PROCESS RULE GROUPS – evaluated first

      preProcessRuleGroups = [
        # 1) Known Bad Inputs
        {
          ruleGroupType = "ManagedRuleGroup"
          priority      = 10
          overrideAction = { type = "NONE" }
          managedRuleGroupIdentifier = {
            vendorName           = "AWS"
            managedRuleGroupName = "AWSManagedRulesKnownBadInputsRuleSet"
            version              = null
          }
          excludeRules = []
          ruleGroupArn = null
        },

        # 2) Common Rule Set (OWASP-ish)
        {
          ruleGroupType = "ManagedRuleGroup"
          priority      = 20
          overrideAction = { type = "NONE" }
          managedRuleGroupIdentifier = {
            vendorName           = "AWS"
            managedRuleGroupName = "AWSManagedRulesCommonRuleSet"
            version              = null
          }
          excludeRules = []
          ruleGroupArn = null
        }
      ]

      #  POST-PROCESS RULE GROUPS – evaluated last

      postProcessRuleGroups = [
        # 3) IP Reputation / Threat Intel
        {
          ruleGroupType = "ManagedRuleGroup"
          priority      = 9901
          overrideAction = { type = "NONE" }
          managedRuleGroupIdentifier = {
            vendorName           = "AWS"
            managedRuleGroupName = "AWSManagedRulesAmazonIpReputationList"
            version              = null
          }
          excludeRules = []
          ruleGroupArn = null
        }
      ]

      #  Default action if nothing matches the rule groups
      defaultAction = {
        type = "ALLOW"
      }
    })
  }

} */


resource "aws_fms_policy" "cloudfront_waf_policy" {
  name                       = "cloudfront-default-protections"
  delete_all_policy_resources = false

  # -----------------------------
  # Scope: which accounts / resources
  # -----------------------------
  # Adjust this for your org:
  # - use include_map / exclude_map as needed
  # - or use "orgunit" if you want to target OUs
  include_map {
    account = [
      var.prod_account_id
      # or just target all accounts in org and use exclusions
    ]
  }

  resource_type         = "AWS::CloudFront::Distribution"
  remediation_enabled   = true
  exclude_resource_tags = false

  # Match distributions by tag (optional, but recommended)
  # If you want ALL distributions, you can leave resource_tags empty.
  /* resource_tags = {
    Name = "cloudfront-default"
  } */

  security_service_policy_data {
    type = "WAFV2"

    # This JSON describes the WebACL + WAFv2 behavior that FMS will enforce
    managed_service_data = jsonencode({
      type = "WAFV2"

      # We’re letting FMS create and manage the WebACL for us
      preProcessFirewallManagerRuleGroups = []
      postProcessFirewallManagerRuleGroups = []

      # Whether to override existing WAF on matching distributions
      overrideCustomerWebACLAssociation = true

      # The actual WebACL config we want FMS to deploy
      webacl = {
        name        = "cloudfront-default-protections"
        description = "Baseline + L7 DDoS protections for CloudFront"
        defaultAction = {
          type = "ALLOW"
        }
        visibilityConfig = {
          cloudWatchMetricsEnabled = true
          metricName               = "cloudfront-default-plus-l7-ddos"
          sampledRequestsEnabled   = true
        }

        # --------------------------------
        # Managed rule groups (same as your WebACL)
        # --------------------------------
        rules = [
          {
            name     = "AWSManagedRulesAmazonIpReputationList"
            priority = 1
            statement = {
              managedRuleGroupStatement = {
                vendorName = "AWS"
                name       = "AWSManagedRulesAmazonIpReputationList"
              }
            }
            overrideAction = {
              none = {}
            }
            visibilityConfig = {
              cloudWatchMetricsEnabled = true
              metricName               = "AWSManagedRulesAmazonIpReputationList"
              sampledRequestsEnabled   = true
            }
          },
          {
            name     = "AWSManagedRulesKnownBadInputsRuleSet"
            priority = 2
            statement = {
              managedRuleGroupStatement = {
                vendorName = "AWS"
                name       = "AWSManagedRulesKnownBadInputsRuleSet"
              }
            }
            overrideAction = {
              none = {}
            }
            visibilityConfig = {
              cloudWatchMetricsEnabled = true
              metricName               = "AWSManagedRulesKnownBadInputsRuleSet"
              sampledRequestsEnabled   = true
            }
          },
          {
            name     = "AWSManagedRulesCommonRuleSet"
            priority = 3
            statement = {
              managedRuleGroupStatement = {
                vendorName = "AWS"
                name       = "AWSManagedRulesCommonRuleSet"
              }
            }
            overrideAction = {
              none = {}
            }
            visibilityConfig = {
              cloudWatchMetricsEnabled = true
              metricName               = "AWSManagedRulesCommonRuleSet"
              sampledRequestsEnabled   = true
            }
          }
        ]
      }
    })
  }

  tags = {
    Name = "cloudfront-default-protections-l7-ddos"
  }
}
