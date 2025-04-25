variable "snowflake_account_name" {}
variable "snowflake_organization_name" {}
variable "snowflake_user" {}
variable "snowflake_password" {
  sensitive = true
}

variable "snowflake_account_name_2" {}
variable "snowflake_organization_name_2" {}
variable "snowflake_user_2" {}
variable "snowflake_password_2" {
  sensitive = true
}
