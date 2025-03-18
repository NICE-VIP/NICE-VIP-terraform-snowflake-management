terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

variable "user_password"{}

provider "snowflake" {
  role = "USERADMIN"
}

resource "snowflake_user" "user1" {
  name         = "Jayesh Soni"
  login_name   = "jayesh_soni"

  email = "jayyesh26@gmail.com"

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

  email = "anujjoshi89@gmail.com"

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

  email = "samirsw04@gmail.com"
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

  email = "shreenath8.b@gmail.com"
  password = var.user_password

  first_name   = "Shreenath"
  last_name    = "Bandivadekar"

  comment      = "User created using the tf-snow user"
  display_name = "Shreenath Bandivadekar"
  must_change_password = "true"

}