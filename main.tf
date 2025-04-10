terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  alias      = "sysadmin"
  role       = "SYSADMIN"
}

provider "snowflake" {
  alias      = "accountadmin"
  role       = "ACCOUNTADMIN"
}


provider "snowflake" {
  alias  = "security_admin"
  role   = "SECURITYADMIN"
}

provider "snowflake" {
  alias  = "infra_admin"
  role   = "INFRA_ADMIN_ROLE"
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
    snowflake.sysadmin = snowflake.sysadmin
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