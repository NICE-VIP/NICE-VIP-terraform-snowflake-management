resource "snowflake_authentication_policy" "mfa_on_db_app" {
  provider = snowflake.infra_admin_alias
  database                   = "APP_DATA_DB"
  schema                     = "PUBLIC"
  name                       = "auth_policy_mfa"
  authentication_methods     = ["ALL"]
  mfa_authentication_methods = ["SAML", "PASSWORD"]
  mfa_enrollment             = "REQUIRED"
  client_types               = ["ALL"]
  security_integrations      = ["ALL"]
}

resource "snowflake_user_authentication_policy_attachment" "auth_policy_for_user" {
    provider = snowflake.security_admin
  authentication_policy_name = "${snowflake_authentication_policy.mfa_on_db_app.database}.${snowflake_authentication_policy.mfa_on_db_app.schema}.${snowflake_authentication_policy.mfa_on_db_app.name}"
  user_name                  = "Shreenath Bandivadekar"
}
