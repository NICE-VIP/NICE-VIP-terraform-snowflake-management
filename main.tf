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