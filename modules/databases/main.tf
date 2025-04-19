terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
      configuration_aliases = [ snowflake.infra_admin, snowflake.sysadmin ]
    }
  }
}

# Locals for reuse
locals {
  databases = {
    APP_DATA_DB = {
      comment = "Database for application data."
      schema  = "APP_DATA_DB_SCHEMA"
    }
    LOGS_DB = {
      comment = "Database for logging data."
      schema  = "LOGS_DB_SCHEMA"
    }
  }
}

# Create Databases and Schemas
resource "snowflake_database" "dbs" {
  provider = snowflake.infra_admin
  for_each = local.databases
  name     = each.key
  comment  = each.value.comment
}

resource "snowflake_schema" "schemas" {
  provider = snowflake.infra_admin
  for_each = local.databases
  database = each.key
  name     = each.value.schema
}

# Grant privileges to data_admin
resource "snowflake_grant_privileges_to_account_role" "data_admin_db_privs" {
  for_each = local.databases
  provider          = snowflake.infra_admin
  account_role_name = var.data_admin_role
  privileges        = ["MODIFY", "USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = each.key
  }
}

resource "snowflake_grant_privileges_to_account_role" "data_admin_schema_object_privs" {
  for_each = local.databases
  provider          = snowflake.infra_admin
  account_role_name = var.data_admin_role
  privileges        = ["INSERT", "UPDATE", "DELETE", "SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.schemas[each.key].fully_qualified_name
    }
  }
}

# Grant privileges to read_only
resource "snowflake_grant_privileges_to_account_role" "read_only_db_privs" {
  for_each = local.databases
  provider          = snowflake.infra_admin
  account_role_name = var.read_only_role
  privileges        = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = each.key
  }
}

resource "snowflake_grant_privileges_to_account_role" "read_only_schema_object_privs" {
  for_each = local.databases
  provider          = snowflake.infra_admin
  account_role_name = var.read_only_role
  privileges        = ["SELECT"]
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema = snowflake_schema.schemas[each.key].fully_qualified_name
    }
  }
}