terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  role = "USERADMIN"
}

resource "snowflake_user" "user" {
  name         = "Snowflake_User_01"
  login_name   = "Snowflake_User_01"

  comment      = "User created using the tf-snow user which has the role of USERADMIN"
  display_name = "Snowflake_User_01"
  must_change_password = "true"
}