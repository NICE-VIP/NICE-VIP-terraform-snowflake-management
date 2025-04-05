terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN"
}
# --- Create Three Custom Roles ---
resource "snowflake_account_role" "infra_admin" {
  name    = "INFRA_ADMIN_ROLE"
  comment = "Infrastructure admin role with full privileges over warehouses and databases."
}

resource "snowflake_grant_account_role" "infra_admin_grant" {
  role_name = snowflake_account_role.infra_admin.name
  parent_role_name = "SYSADMIN"
}

resource "snowflake_account_role" "data_admin" {
  name    = "DATA_ADMIN_ROLE"
  comment = "Data admin role with full control over databases."
}

resource "snowflake_grant_account_role" "data_admin_grant" {
  role_name = snowflake_account_role.data_admin.name
  parent_role_name = snowflake_account_role.infra_admin.name
}

resource "snowflake_account_role" "read_only" {
  name    = "READ_ONLY_ROLE"
  comment = "Read-only role with SELECT and USAGE privileges."
}

resource "snowflake_grant_account_role" "read_only_grant" {
  role_name = snowflake_account_role.read_only.name
  parent_role_name = snowflake_account_role.data_admin.name
}

# --- Create Databases ---
resource "snowflake_database" "app_data_db" {
  name    = "APP_DATA_DB"
  comment = "Database for application data."
}

resource "snowflake_database" "logs_db" {
  name    = "LOGS_DB"
  comment = "Database for logging data."
}

# Schema initialization
resource "snowflake_schema" "app_data_db_schema" {
  database = snowflake_database.app_data_db.name
  name     = "APP_DATA_DB_SCHEMA"
}
resource "snowflake_schema" "logs_db_schema" {
  database = snowflake_database.logs_db.name
  name     = "LOGS_DB_SCHEMA"
}

# Grant privileges to roles
resource "snowflake_grant_ownership" "infra_admin_app_data_db_ownership" {
  account_role_name = snowflake_account_role.infra_admin.name
  on {
    object_type = "DATABASE"
    object_name = snowflake_database.app_data_db.name
  }
}
resource "snowflake_grant_ownership" "infra_admin_logs_db_ownership" {
  account_role_name = snowflake_account_role.infra_admin.name
  on {
    object_type = "DATABASE"
    object_name = snowflake_database.logs_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_app_data_db_privs" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges    = ["MODIFY", "USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.app_data_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_app_data_db_schema_object_privs" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges    = ["INSERT", "UPDATE", "DELETE", "SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.app_data_db_schema.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_logs_db_privs" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges    = ["MODIFY", "USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.logs_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_logs_db_schema_object_privs" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges    = ["INSERT", "UPDATE", "DELETE", "SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.logs_db_schema.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_only_app_data_db_privs" {
  account_role_name = snowflake_account_role.read_only.name
  privileges    = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.app_data_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_only_app_data_db_schema_object_privs" {
  account_role_name = snowflake_account_role.read_only.name
  privileges    = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.app_data_db_schema.fully_qualified_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_only_logs_db_privs" {
  account_role_name = snowflake_account_role.read_only.name
  privileges    = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.logs_db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_only_logs_db_schema_object_privs" {
  account_role_name = snowflake_account_role.read_only.name
  privileges    = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.logs_db_schema.fully_qualified_name
    }
  }
}

# --- Create Warehouses ---
resource "snowflake_warehouse" "data_processing_wh" {
  name                   = "DATA_PROCESSING_WH"
  warehouse_size         = "XSMALL"
  auto_suspend           = 60
  auto_resume            = true
  min_cluster_count      = 1
  max_cluster_count      = 10
  scaling_policy         = "STANDARD"
  initially_suspended    = true
  resource_monitor       = snowflake_resource_monitor.warehouse_usage_monitor.name
}

resource "snowflake_warehouse" "logs_processing_wh" {
  name                   = "LOGS_PROCESSING_WH"
  warehouse_size         = "XSMALL"
  auto_suspend           = 60
  auto_resume            = true
  min_cluster_count      = 1
  max_cluster_count      = 10
  scaling_policy         = "STANDARD"
  initially_suspended    = true
  resource_monitor       = snowflake_resource_monitor.warehouse_usage_monitor.name
}

# Ownership to Infra Admin
resource "snowflake_grant_ownership" "infra_admin_data_processing_wh_ownership" {
  account_role_name = snowflake_account_role.infra_admin.name
  on {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.data_processing_wh.name
  }
}
resource "snowflake_grant_ownership" "infra_admin_logs_processing_wh_ownership" {
  account_role_name = snowflake_account_role.infra_admin.name
  on {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.logs_processing_wh.name
  }
}

# Grant USAGE on warehouses
resource "snowflake_grant_privileges_to_account_role" "data_admin_data_processing_wh_privs" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges     = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.data_processing_wh.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_logs_processing_wh_privs" {
  account_role_name = snowflake_account_role.read_only.name
  privileges     = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.logs_processing_wh.name
  }
}

# --- 4. Create Network Policy ---
resource "snowflake_network_policy" "allow_ip_network_policy" {
  name                      = "ALLOW_IP"
  allowed_ip_list           = ["0.0.0.0/0"]
  comment                   = "my network policy"
}

# --- Create Resource Monitors ---
resource "snowflake_resource_monitor" "account_usage_monitor" {
  name                     = "ACCOUNT_USAGE_MONITOR"
  credit_quota             = 100
  notify_triggers          = [80]
  suspend_trigger          = 90
  suspend_immediate_trigger = 90
  notify_users             = ["SAMIRWANKHEDE"]
}

resource "snowflake_resource_monitor" "warehouse_usage_monitor" {
  name                     = "WAREHOUSE_USAGE_MONITOR"
  credit_quota             = 100
  notify_triggers          = [80]
  suspend_trigger         = 90
  suspend_immediate_trigger = 90
  notify_users             = ["SAMIRWANKHEDE"]
}
