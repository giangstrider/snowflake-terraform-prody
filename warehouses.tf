resource "snowflake_warehouse" "warehouse_loader" {
  name                  = "LOADER_WH"
  comment               = "Warehouse for Data Load"
  warehouse_size        = "xsmall"
  max_cluster_count     = 2
  min_cluster_count     = 1
  scaling_policy        = "STANDARD"
  initially_suspended   = true
  auto_resume           = true
  auto_suspend          = 60
  statement_timeout_in_seconds = 1800

  lifecycle {
    ignore_changes = [
      warehouse_size, max_cluster_count, scaling_policy, auto_suspend
    ]
  }
}

resource "snowflake_warehouse" "warehouse_consumer" {
  name                  = "CONSUMER_WH"
  comment               = "Warehouse for user consumerr"
  warehouse_size        = "xsmall"
  max_cluster_count     = 2
  min_cluster_count     = 1
  scaling_policy        = "STANDARD"
  initially_suspended   = true
  auto_resume           = true
  auto_suspend          = 60
  statement_timeout_in_seconds = 3600

  lifecycle {
    ignore_changes = [
      warehouse_size, max_cluster_count, scaling_policy, auto_suspend
    ]
  }
}
