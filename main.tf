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
  organization_name = var.org_name
  account_name      = var.account_name
  role              = "SECURITYADMIN"
}

# Create Roles
resource "snowflake_role" "infra_admin" {
  name = "INFRA_ADMIN_ROLE"
}

resource "snowflake_role" "data_admin" {
  name = "DATA_ADMIN_ROLE"
}

resource "snowflake_role" "read_only" {
  name = "READ_ONLY_ROLE"
}

# Grant role hierarchy

resource "snowflake_grant_account_role" "grant_infra_to_sysadmin" {
  role_name        = snowflake_role.infra_admin.name
  parent_role_name = "SYSADMIN"
}

resource "snowflake_grant_account_role" "grant_data_to_infra" {
  role_name    = snowflake_role.data_admin.name
  parent_role_name =  snowflake_role.infra_admin.name
}

resource "snowflake_grant_account_role" "grant_read_to_data" {
  role_name    = snowflake_role.read_only.name
  parent_role_name =  snowflake_role.data_admin.name
}

