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
}

module "roles" {
  source = "./modules/roles"

  providers = {
    snowflake.sysadmin       = snowflake.sysadmin
    snowflake.security_admin = snowflake.security_admin
    snowflake.infra_admin    = snowflake.infra_admin
  }
}