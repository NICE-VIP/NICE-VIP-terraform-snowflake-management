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