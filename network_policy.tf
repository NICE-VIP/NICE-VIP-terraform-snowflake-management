# network policy

resource "snowflake_network_policy" "network_policy_allow_ip" {
  provider        = snowflake.account_admin
  name            = "ALLOW_IP"
  allowed_ip_list = ["0.0.0.0/0"]
  comment         = "A network policy"
}
