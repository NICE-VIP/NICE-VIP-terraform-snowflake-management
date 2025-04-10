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

