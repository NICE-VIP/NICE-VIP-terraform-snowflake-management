// 3. create warehouses


resource "snowflake_warehouse" "warehouse_data_processing" {
  provider            = snowflake.infra_admin_alias
  name                = "DATA_PROCESSING_WH"
  warehouse_size      = "XSMALL"
  max_cluster_count   = 10
  min_cluster_count   = 1
  scaling_policy      = "STANDARD"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  comment             = "This is the DATA_PROCESSING_WH"
}

resource "snowflake_warehouse" "warehouse_logs_processing" {
  provider            = snowflake.infra_admin_alias
  name                = "LOGS_PROCESSING_WH"
  warehouse_size      = "XSMALL"
  max_cluster_count   = 10
  min_cluster_count   = 1
  scaling_policy      = "STANDARD"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  comment             = "This is the LOGS_PROCESSING_WH"
}

resource "snowflake_grant_privileges_to_account_role" "grant_data_processing_usage_to_data_admin" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse_data_processing.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_logs_processing_usage_to_data_admin" {
  account_role_name = snowflake_account_role.data_admin.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse_logs_processing.name
  }
}


resource "snowflake_grant_privileges_to_account_role" "grant_data_processing_usage_to_read_only" {
  account_role_name = snowflake_account_role.read_only.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse_data_processing.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_logs_processing_usage_to_read_only" {
  account_role_name = snowflake_account_role.read_only.name
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse_logs_processing.name

  }
}
