terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
      configuration_aliases = [ snowflake.infra_admin, snowflake.accountadmin ]
    }
  }
}

locals {
  warehouse_names = ["DATA_PROCESSING_WH", "LOGS_PROCESSING_WH"]
}

# create warehouses
resource "snowflake_warehouse" "infra_admin_wh" {
  provider               = snowflake.infra_admin
  for_each               = toset(local.warehouse_names)
  name                   = each.key
  warehouse_size         = "XSMALL"
  auto_suspend           = 60
  auto_resume            = true
  initially_suspended    = true
  min_cluster_count      = 1
  max_cluster_count      = 10
  scaling_policy         = "STANDARD"
}

#create grants on warehouse
resource "snowflake_grant_privileges_to_account_role" "data_admin_data_processing_wh_privs" {
  for_each = toset(local.warehouse_names)
  account_role_name = var.data_admin_role
  provider = snowflake.infra_admin
  privileges     = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = each.key
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_logs_processing_wh_privs" {
  for_each = toset(local.warehouse_names)
  account_role_name = var.read_only_role
  provider = snowflake.infra_admin
  privileges     = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = each.key
  }
}