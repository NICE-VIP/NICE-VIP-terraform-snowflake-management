terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  alias = "sysadmin"
}

provider "snowflake" {
  alias = "security_admin"
}

provider "snowflake" {
  alias = "infra_admin"
}

# ============================
# Role Hierarchy Definitions
# ============================

locals {
  security_admin_grants = {
    infra_admin_to_sysadmin = {
      parent = "SYSADMIN"
      child  = snowflake_account_role.infra_admin.name
    }
  }
}

# Create INFRA_ADMIN_ROLE
resource "snowflake_account_role" "infra_admin" {
  provider = snowflake.security_admin
  name    = "INFRA_ADMIN_ROLE"
  comment = "Manages infrastructure resources"
}

# Grant CREATE DATABASE and CREATE WAREHOUSE to INFRA_ADMIN_ROLE
resource "snowflake_grant_privileges_to_account_role" "grant_to_infra_admin" {
  provider          = snowflake.sysadmin
  account_role_name = snowflake_account_role.infra_admin.name
  privileges        = ["CREATE DATABASE", "CREATE WAREHOUSE"]
  on_account        = true
}

# Grant CREATE ROLE privilege to INFRA_ADMIN_ROLE
resource "snowflake_grant_privileges_to_account_role" "grant_create_role_to_infra_admin" {
  provider          = snowflake.security_admin
  account_role_name = snowflake_account_role.infra_admin.name
  privileges        = ["CREATE ROLE"]
  on_account        = true
}

# Role hierarchy
resource "snowflake_grant_account_role" "security_admin_hierarchy" {
  for_each = local.security_admin_grants
  provider  = snowflake.security_admin
  parent_role_name = each.value.parent
  role_name     = each.value.child
}
