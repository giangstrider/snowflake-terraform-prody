# ==========================================
# Sysadmin
# ==========================================
resource "snowflake_warehouse_grant" "sysadmin_warehouses_grant_w" {
  provider = snowflake.security_admin

  for_each = {
    for o in [
        for pair in setproduct(
            [
                snowflake_warehouse.warehouse_loader.name,
                snowflake_warehouse.warehouse_consumer.name
            ],
            local.warehouse_write_privileges
        ) : {
          warehouse = pair[0]
          privilege = pair[1]
        }
    ]: "${o.warehouse}:${o.privilege}" => o
  }

  warehouse_name = each.value.warehouse
  privilege      = each.value.privilege

  roles = ["SYSADMIN"]
}


# ==========================================
# Service Role
# ==========================================
resource "snowflake_warehouse_grant" "loader_warehouses_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.warehouse_read_privileges)

  warehouse_name = snowflake_warehouse.warehouse_loader.name
  privilege      = each.value

  roles = [
    "SYSADMIN",
    snowflake_role.role_data_engineer.name,
    snowflake_role.role_analyst.name
    ]
}

resource "snowflake_warehouse_grant" "loader_warehouses_grant_u" {
  provider = snowflake.security_admin
  for_each = toset(local.warehouse_usage_privileges)

  warehouse_name = snowflake_warehouse.warehouse_loader.name
  privilege      = each.value

  roles = [
    "SYSADMIN",
    snowflake_role.role_sv_airflow.name,
    snowflake_role.role_dev_sv_airflow.name,
    snowflake_role.role_sv_stitch.name
    ]
}

resource "snowflake_warehouse_grant" "consumer_warehouses_grant_ru" {
  provider = snowflake.security_admin
  for_each = toset(concat(local.warehouse_read_privileges, local.warehouse_usage_privileges))

  warehouse_name = snowflake_warehouse.warehouse_consumer.name
  privilege      = each.value

  roles = concat(
    [
    "SYSADMIN",
    snowflake_role.role_data_engineer.name,
    snowflake_role.role_analyst.name,
    ],
    [for role in snowflake_role.org_user_role : role.name]
  )
}
