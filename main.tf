terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
  cloud { 
    hostname = "app.terraform.io"
    organization = "nice-vip" 
    workspaces { 
      name = "nice-vip-assignment-1" 
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
