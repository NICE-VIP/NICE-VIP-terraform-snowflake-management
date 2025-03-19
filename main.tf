terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  role = "SECURITYADMIN"
}

resource "snowflake_grant_account_role" "grants_jayesh" {
  role_name = "SYSADMIN"
  user_name = snowflake_user.user1.name
}

# Grant USERADMIN role to user2 (Anuj Joshi)
resource "snowflake_grant_account_role" "grants_anuj" {
  role_name = "USERADMIN"
  user_name     = snowflake_user.user2.name
}

# Grant PUBLIC role to user4
resource "snowflake_grant_account_role" "grants_shreenath" {
  role_name = "PUBLIC"
  user_name     = snowflake_user.user4.name
}

# Grant multiple roles to user3
resource "snowflake_grant_account_role" "grants_samir_sysadmin" {
  role_name = "SYSADMIN"
  user_name     = snowflake_user.user3.name
}

resource "snowflake_grant_account_role" "grants_samir_useradmin" {
  role_name = "USERADMIN"
  user_name     = snowflake_user.user3.name
}

# Create a custom role
resource "snowflake_account_role" "analyst_role" {
  name    = "ANALYST"
  comment = "Role for data analysts"
}

# Grant the custom role to users
resource "snowflake_grant_account_role" "analyst_grants_samir" {
  role_name = snowflake_account_role.analyst_role.name
  user_name = snowflake_user.user3.name
}
resource "snowflake_grant_account_role" "analyst_grants_shreenath" {
  role_name = snowflake_account_role.analyst_role.name
  user_name = snowflake_user.user4.name
}

resource "snowflake_user" "user1" {
  name         = "Jayesh Soni"
  login_name   = "jayesh_soni"

  email = var.user_emails["jayesh_soni"]

  password = var.user_password

  first_name   = "Jayesh"
  last_name    = "Soni"

  comment      = "User created using the tf-snow user"
  display_name = "Jayesh Soni"
  must_change_password = "true"

}

resource "snowflake_user" "user2" {
  name         = "Anuj Joshi"
  login_name   = "anuj_joshi"

  email = var.user_emails["anuj_joshi"]

  password = var.user_password

  first_name   = "Anuj"
  last_name    = "Joshi"

  comment      = "User created using the tf-snow user"
  display_name = "Anuj Joshi"
  must_change_password = "true"
}

resource "snowflake_user" "user3" {
  name         = "Samir Wankhede"
  login_name   = "samir_wankhede"

  email = var.user_emails["samir_wankhede"]
  password = var.user_password

  first_name   = "Samir"
  last_name    = "Wankhede"

  comment      = "User created using the tf-snow user"
  display_name = "Samir Wankhede"
  must_change_password = "true"

}

resource "snowflake_user" "user4" {
  name         = "Shreenath Bandivadekar"
  login_name   = "shreenath_bandivadekar"

  email = var.user_emails["shreenath_bandivadekar"]
  password = var.user_password

  first_name   = "Shreenath"
  last_name    = "Bandivadekar"

  comment      = "User created using the tf-snow user"
  display_name = "Shreenath Bandivadekar"
  must_change_password = "true"

}