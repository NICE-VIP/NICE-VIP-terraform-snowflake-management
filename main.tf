terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}


variable "org_name"{}
variable "account_name"{}

provider "snowflake" {
  alias             = "security_admin"
  role              = "SECURITYADMIN"
  organization_name = var.org_name
  account_name      = var.account_name
}

provider "snowflake" {
  alias             = "sys_admin"
  role              = "SYSADMIN"
  organization_name = var.org_name
  account_name      = var.account_name
}

provider "snowflake" {
  alias             = "infra_admin_alias"
  role              = "INFRA_ADMIN_ROLE"
  organization_name = var.org_name
  account_name      = var.account_name
}

resource "snowflake_account_role" "infra_admin" {
  provider = snowflake.security_admin
  name     = "INFRA_ADMIN_ROLE"
}

resource "snowflake_grant_privileges_to_account_role" "grant_to_infra_admin" {
  provider          = snowflake.sys_admin
  account_role_name = snowflake_account_role.infra_admin.name
  privileges        = ["CREATE DATABASE", "CREATE WAREHOUSE"]
  on_account        = true
}

resource "snowflake_grant_privileges_to_account_role" "grant_create_role_to_infra_admin" {
  provider          = snowflake.security_admin
  account_role_name = snowflake_account_role.infra_admin.name
  privileges        = ["CREATE ROLE"]
  on_account        = true
}

resource "snowflake_database" "app_data_db" {
  provider = snowflake.infra_admin_alias
  name = "APP_DATA_DB"
  comment = "This database holds all of the app data."
}

resource "snowflake_database" "logs_db" {
  provider = snowflake.infra_admin_alias
  name = "LOGS_DB"
  comment = "This database holds all of the log data."
}

resource "snowflake_account_role" "data_admin"{
    provider = snowflake.infra_admin_alias
    name = "DATA_ADMIN_ROLE"
}

resource "snowflake_grant_account_role" "assign_data_admin_to_infra" {
  role_name        = snowflake_account_role.data_admin.name
  parent_role_name = snowflake_account_role.infra_admin.name
}


# resource "snowflake_grant_privileges_to_account_role" "app_db_schema_privs" {
#   provider            = snowflake.infra_admin_alias
#   account_role_name   = snowflake_account_role.data_admin.name
#   privileges          = ["USAGE", "SELECT", "INSERT", "UPDATE", "DELETE", "MODIFY"]
#   on_schema {
#     schema_name = "${snowflake_database.app_data_db.name}.PUBLIC"
#   }
# }

# for data admin role


resource "snowflake_grant_privileges_to_account_role" "app_db_schema_usage" {
  provider            = snowflake.infra_admin_alias
  account_role_name   = snowflake_account_role.data_admin.name
  privileges          = ["USAGE"]
  on_schema {
    schema_name   = "${snowflake_database.app_data_db.name}.PUBLIC"
  }
}



resource "snowflake_grant_privileges_to_account_role" "app_db_tables_usage" {
  provider          = snowflake.infra_admin_alias
  privileges        = ["SELECT", "INSERT", "UPDATE", "DELETE"] // Modify??
  account_role_name   = snowflake_account_role.data_admin.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "${snowflake_database.app_data_db.name}.PUBLIC"
    }
  }
}


resource "snowflake_grant_privileges_to_account_role" "logs_db_schema_usage" {
  provider            = snowflake.infra_admin_alias
  account_role_name   = snowflake_account_role.data_admin.name
  privileges          = ["USAGE"]
  on_schema {
    schema_name   = "${snowflake_database.logs_db.name}.PUBLIC"
  }
}


resource "snowflake_grant_privileges_to_account_role" "logs_db_tables_usage" {
  provider          = snowflake.infra_admin_alias
  privileges        = ["SELECT", "INSERT", "UPDATE", "DELETE"] // Modify??
  account_role_name   = snowflake_account_role.data_admin.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "${snowflake_database.logs_db.name}.PUBLIC"
    }
  }
}


# read only role

resource "snowflake_account_role" "read_only"{
    provider = snowflake.infra_admin_alias
    name = "READ_ONLY_ROLE"
}

resource "snowflake_grant_account_role" "assign_read_only_to_data_admin" {
  role_name        = snowflake_account_role.read_only.name
  parent_role_name = snowflake_account_role.data_admin.name
}


resource "snowflake_grant_privileges_to_account_role" "app_db_tables_usage_by_read_only" {
  provider          = snowflake.infra_admin_alias
  privileges        = ["SELECT", "INSERT", "UPDATE", "DELETE"] // Modify??
  account_role_name   = snowflake_account_role.read_only.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "${snowflake_database.app_data_db.name}.PUBLIC"
    }
  }
}



resource "snowflake_grant_privileges_to_account_role" "logs_db_tables_usage_by_read_only" {
  provider          = snowflake.infra_admin_alias
  privileges        = ["SELECT", "INSERT", "UPDATE", "DELETE"] // Modify??
  account_role_name   = snowflake_account_role.read_only.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = "${snowflake_database.logs_db.name}.PUBLIC"
    }
  }
}


resource "snowflake_grant_privileges_to_account_role" "app_db_schema_usage_by_read_only" {
  provider            = snowflake.infra_admin_alias
  account_role_name   = snowflake_account_role.read_only.name
  privileges          = ["USAGE"]
  on_schema {
    schema_name   = "${snowflake_database.app_data_db.name}.PUBLIC"
  }
}

resource "snowflake_grant_privileges_to_account_role" "logs_db_schema_usage_by_read_only" {
  provider            = snowflake.infra_admin_alias
  account_role_name   = snowflake_account_role.read_only.name
  privileges          = ["USAGE"]
  on_schema {
    schema_name   = "${snowflake_database.logs_db.name}.PUBLIC"
  }
}