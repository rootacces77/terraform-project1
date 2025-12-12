resource "aws_networkfirewall_rule_group" "egress_stateful" {
  capacity = 100
  name     = "FirewallRules"
  type     = "STATEFUL"

  rule_group {
    rule_variables {}
    rules_source {
      rules_string = <<-EOT
drop tcp any any -> any any (msg:"Egress Bash reverse shell attempt"; content:"/bin/bash"; nocase; sid:10001; rev:1;)
drop tcp any any -> any any (msg:"C2 CobaltStrike UA Trident"; content:"Trident/7.0"; http_user_agent; sid:10005; rev:1;)
pass tcp any any -> any 443 (msg:"Egress Allowed HTTPS 443"; sid:20001; rev:1;)
pass tcp any any -> any 80 (msg:"Egress Allowed HTTP 80"; sid:20002; rev:1;)
drop tcp any any -> any any (msg:"Egress Blocked non HTTP HTTPS"; sid:20003; rev:1;)
      EOT
    }
  }
}
  # Firewall Manager Network Firewall policy
resource "aws_fms_policy" "network_fw" {
  name                  = "network-firewall-egress"
  delete_all_policy_resources = false

  # Scope: which accounts
  include_map {
    account = [var.network_account_id]   # or all accounts in org
  }

  # Scope: which VPCs inside those accounts
  resource_type         = "AWS::EC2::VPC"
  exclude_resource_tags = false
  remediation_enabled   = true

  # Only VPCs with this tag are in scope
  resource_tags = {
    Name = "PROD-VPC-APP"
  }

  security_service_policy_data {
    type = "NETWORK_FIREWALL"

    # This JSON is exactly what FMS expects for Network Firewall policies
    # (same structure as in the AWS::FMS::Policy example). :contentReference[oaicite:0]{index=0}
    managed_service_data = jsonencode({
      type = "NETWORK_FIREWALL"

      # Stateless defaults – send everything to stateful engine
      networkFirewallStatelessDefaultActions         = ["aws:forward_to_sfe"]
      networkFirewallStatelessFragmentDefaultActions = ["aws:forward_to_sfe"]

      # We’re only using stateful rules in this minimal example
      networkFirewallStatelessRuleGroupReferences = []
      networkFirewallStatelessCustomActions       = []

      # Attach our stateful rule group
      networkFirewallStatefulRuleGroupReferences = [
        {
          resourceARN = aws_networkfirewall_rule_group.egress_stateful.arn
        }
      ]

      # Orchestration controls how endpoints are created in VPCs
      networkFirewallOrchestrationConfig = {
        singleFirewallEndpointPerVPC = true               # one per AZ
        allowedIPV4CidrList          = []                   # or restrict to your CIDRs
        routeManagementAction      = "MONITOR"         # or "MONITOR" if you only want to observe
        routeManagementTargetTypes = ["InternetGateway"]
      }
    })
  }

  # Optional tagging of the policy itself
  tags = {
    Name = "network-firewall-egress-fms-policy"
  }
}