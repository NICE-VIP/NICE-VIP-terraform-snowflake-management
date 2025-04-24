terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  alias      = "accountadmin"
  role       = "ACCOUNTADMIN"
  account_name      = var.snowflake_account_name
  organization_name = var.snowflake_organization_name
  user              = var.snowflake_user
  password          = var.snowflake_password
  authenticator = "USERNAMEPASSWORDMFA"
  passcode = var.snowflake_passcode
}

provider "snowflake" {
  alias      = "sysadmin"
  role       = "SYSADMIN"
  account_name      = var.snowflake_account_name
  organization_name = var.snowflake_organization_name
  user              = var.snowflake_user
  password          = var.snowflake_password
}

provider "snowflake" {
  alias  = "security_admin"
  role   = "SECURITYADMIN"
  account_name      = var.snowflake_account_name
  organization_name = var.snowflake_organization_name
  user              = var.snowflake_user
  password          = var.snowflake_password
}

provider "snowflake" {
  alias  = "infra_admin"
  role   = "INFRA_ADMIN_ROLE"
  account_name      = var.snowflake_account_name
  organization_name = var.snowflake_organization_name
  user              = var.snowflake_user
  password          = var.snowflake_password
}

module "roles" {
  source = "./modules/roles"

  providers = {
    snowflake.sysadmin       = snowflake.sysadmin
    snowflake.security_admin = snowflake.security_admin
    snowflake.infra_admin    = snowflake.infra_admin
  }
}

module "databases" {
  source = "./modules/databases"
  read_only_role = "READ_ONLY_ROLE"
  data_admin_role = "DATA_ADMIN_ROLE"
  providers = {
    snowflake.sysadmin    = snowflake.sysadmin
    snowflake.infra_admin = snowflake.infra_admin
  }
}

module "warehouses" {
  source = "./modules/warehouses"
  read_only_role = "READ_ONLY_ROLE"
  data_admin_role = "DATA_ADMIN_ROLE"
  providers = {
    snowflake.infra_admin = snowflake.infra_admin
  }
}

module "network_policy" {
  source = "./modules/network_policy"
  providers = {
    snowflake.accountadmin = snowflake.accountadmin
  }
}

module "resource_monitors" {
  source = "./modules/resource_monitors"
  providers = {
    snowflake.accountadmin = snowflake.accountadmin
  }
}