// here are the imports

//warehouse imports
# import {
#   to = module.warehouses.snowflake_warehouse.existing_wh
#   id = "EXISTING_WAREHOUSE"
# }

// network policy imports
import {
  to = module.network_policy_2.snowflake_network_policy.allow_all
  id = "ALLOW_IP"
}

//monitors
import {
  to = module.resource_monitors_2.snowflake_resource_monitor.account_usage_monitor
  id = "ACCOUNT_USAGE_MONITOR"
}

import {
  to = module.resource_monitors_2.snowflake_resource_monitor.warehouse_resource_monitor
  id = "WAREHOUSE_USAGE_MONITOR"
}