terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}


variable "org_name" {}
variable "account_name" {}

provider "snowflake" {
  alias             = "security_admin"
  role              = "SECURITYADMIN"
  organization_name = var.org_name
  account_name      = var.account_name
  warehouse = "DATA_PROCESSING_WH"
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

provider "snowflake" {
  alias             = "account_admin"
  role              = "ACCOUNTADMIN"
  organization_name = var.org_name
  account_name      = var.account_name
}

