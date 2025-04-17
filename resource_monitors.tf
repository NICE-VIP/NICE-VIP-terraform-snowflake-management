# # resource monitors

# resource "snowflake_resource_monitor" "resource_monitor_account_usage" {
#   provider                  = snowflake.account_admin
#   name                      = "ACCOUNT_USAGE_MONITOR"
#   credit_quota              = 100
#   notify_triggers           = [80]
#   suspend_immediate_trigger = 90

#   notify_users = [snowflake_user.user1.name, snowflake_user.user2.name, snowflake_user.user3.name, snowflake_user.user4.name]
# }

# resource "snowflake_resource_monitor" "resource_monitor_warehouse_usage" {
#   provider                  = snowflake.account_admin
#   name                      = "WAREHOUSE_USAGE_MONITOR"
#   credit_quota              = 100
#   notify_triggers           = [80]
#   suspend_immediate_trigger = 90

#   notify_users = [snowflake_user.user1.name, snowflake_user.user2.name, snowflake_user.user3.name, snowflake_user.user4.name]
# }