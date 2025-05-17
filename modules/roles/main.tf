terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
      configuration_aliases = [ snowflake.infra_admin, snowflake.security_admin, snowflake.sysadmin, ] 
    }
  }
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

  infra_admin_grants = {
    data_admin_to_infra_admin = {
        parent = snowflake_account_role.infra_admin.name
        child = snowflake_account_role.data_admin.name
    }
    read_only_to_infra_admin = {
        parent = snowflake_account_role.data_admin.name
        child = snowflake_account_role.read_only.name
    }
  }
}

# Create INFRA_ADMIN_ROLE
resource "snowflake_account_role" "infra_admin" {
  provider = snowflake.security_admin
  name    = "INFRA_ADMIN_ROLE"
  comment = "Manages infrastructure resources"
}

# Create roles using INFRA_ADMIN_ROLE
resource "snowflake_account_role" "data_admin" {
  provider = snowflake.infra_admin
  name     = "DATA_ADMIN_ROLE"
  comment  = "Manages data-level operations"
}

resource "snowflake_account_role" "read_only" {
  provider = snowflake.infra_admin
  name     = "READ_ONLY_ROLE"
  comment  = "Read-only access for analysts"
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

resource "snowflake_grant_account_role" "infra_admin_hierarchy" {
  for_each = local.infra_admin_grants
  provider  = snowflake.infra_admin
  parent_role_name = each.value.parent
  role_name     = each.value.child
}

## DEMO ROLE:
resource "snowflake_account_role"  "demo_admin" {
  provider = snowflake.infra_admin
  name     = "DEMO_ADMIN_ROLE"
  comment  = "Manages demo-level operations"
}

resource "snowflake_grant_account_role" "infra_admin_demo_grant" {
  provider          = snowflake.infra_admin
  parent_role_name  = snowflake_account_role.infra_admin.name
  role_name         = snowflake_account_role.demo_admin.name
}