terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
      configuration_aliases = [ snowflake.accountadmin ]
    }
  }
}

resource "snowflake_resource_monitor" "account_usage_monitor" {
  name                      = "ACCOUNT_USAGE_MONITOR"
  provider                  = snowflake.accountadmin
  credit_quota              = 100
  notify_triggers           = [80]
  suspend_trigger           = 90
  suspend_immediate_trigger = 90
  notify_users              = var.notify_users
}

resource "snowflake_resource_monitor" "warehouse_usage_monitor" {
  name                      = "WAREHOUSE_USAGE_MONITOR"
  provider                  = snowflake.accountadmin
  credit_quota              = 100
  notify_triggers           = [80]
  suspend_trigger           = 90
  suspend_immediate_trigger = 90
  notify_users              = var.notify_users
}

output "warehouse_resource_monitor" {
  value = snowflake_resource_monitor.warehouse_usage_monitor.fully_qualified_name
}
