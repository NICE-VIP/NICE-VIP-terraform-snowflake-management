terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.87"
      configuration_aliases = [ snowflake.accountadmin ]
    }
  }
}

resource "snowflake_network_policy" "allow_all" {
  name     = "ALLOW_IP"
  provider = snowflake.accountadmin 
  allowed_ip_list = ["0.0.0.0/0"]
  comment  = "Allow all IPs (for testing only)"
}
