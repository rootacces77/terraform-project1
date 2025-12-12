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


/*resource "aws_fms_policy" "cloudfront_waf_policy" {
  name                        = "cloudfront-default-protections123"
  delete_all_policy_resources = false

  # Which accounts to include – adjust as needed
  include_map {
    account = [
      var.prod_account_id
    ]
  }

  resource_type         = "AWS::CloudFront::Distribution"
  remediation_enabled   = true
  exclude_resource_tags = false

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type = "WAFV2"

      # ⬅️ THIS is what the error was about – must be top level
      defaultAction = {
        type = "ALLOW"
      }

      overrideCustomerWebACLAssociation = true

      # Rules that run BEFORE any customer rule groups
      preProcessRuleGroups = [
        {
          name          = "AWSManagedRulesAmazonIpReputationList"
          priority      = 1
          ruleGroupType = "ManagedRuleGroup"
          managedRuleGroupIdentifier = {
            vendorName          = "AWS"
            managedRuleGroupName = "AWSManagedRulesAmazonIpReputationList"
          }
          # Same effect as override_action { none {} } in your WebACL
          overrideAction = {
            type = "NONE"
          }
          visibilityConfig = {
            cloudWatchMetricsEnabled = true
            metricName               = "AWSManagedRulesAmazonIpReputationList"
            sampledRequestsEnabled   = true
          }
        },
        {
          name          = "AWSManagedRulesKnownBadInputsRuleSet"
          priority      = 2
          ruleGroupType = "ManagedRuleGroup"
          managedRuleGroupIdentifier = {
            vendorName          = "AWS"
            managedRuleGroupName = "AWSManagedRulesKnownBadInputsRuleSet"
          }
          overrideAction = {
            type = "NONE"
          }
          visibilityConfig = {
            cloudWatchMetricsEnabled = true
            metricName               = "AWSManagedRulesKnownBadInputsRuleSet"
            sampledRequestsEnabled   = true
          }
        },
        {
          name          = "AWSManagedRulesCommonRuleSet"
          priority      = 3
          ruleGroupType = "ManagedRuleGroup"
          managedRuleGroupIdentifier = {
            vendorName          = "AWS"
            managedRuleGroupName = "AWSManagedRulesCommonRuleSet"
          }
          overrideAction = {
            type = "NONE"
          }
          visibilityConfig = {
            cloudWatchMetricsEnabled = true
            metricName               = "AWSManagedRulesCommonRuleSet"
            sampledRequestsEnabled   = true
          }
        }
      ]

      # Nothing after customer rule groups (you can add more later if needed)
      postProcessRuleGroups = []

      # Optional – you can add loggingConfiguration here later
      # loggingConfiguration = { ... }
    })
  }

  tags = {
    Name = "cloudfront-default-protections-l7-ddos"
  }
} */
