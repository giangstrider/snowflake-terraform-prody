# ==========================================
# Database - 3rd party fully manage this database
# ==========================================
resource "snowflake_database" "database_raw_stitch" {
  name                        = "RAW_STITCH"
  comment                     = "Stitch database"
  data_retention_time_in_days = 30
}

resource "snowflake_database_grant" "database_raw_stitch_grant_3rd" {
  provider = snowflake.security_admin
  for_each = toset(local.database_third_party_ingestion_privileges)

  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_stitch.name
  ]
}

resource "snowflake_database_grant" "database_raw_stitch_grant_rw" {
  provider = snowflake.security_admin
  for_each = toset(concat(
    local.database_read_privileges, 
    local.database_write_privileges
  ))

  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_stitch.name,
    snowflake_role.role_sv_airflow.name,
    snowflake_role.data_engineers.name,
    snowflake_role.analysts.name
  ]
}

# ==========================================
# Schema
# ==========================================
# General grant
resource "snowflake_schema_grant" "database_raw_stitch_schema_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.schema_read_privileges)
  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_stitch.name,
    snowflake_role.role_sv_airflow.name,
    snowflake_role.data_engineers.name,
    snowflake_role.analysts.name
]
  on_future = true
}

resource "snowflake_schema_grant" "database_raw_stitch_schema_grant_w" {
  provider = snowflake.security_admin
  for_each = toset(local.schema_write_privileges)

  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_stitch.name
  ]
  on_future = true
}


# ==========================================
# Table
# ==========================================
resource "snowflake_table_grant" "database_raw_stitch_table_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.table_read_privileges)

  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
     "SYSADMIN",
      snowflake_role.role_sv_stitch.name,
      snowflake_role.role_sv_airflow.name,
      snowflake_role.data_engineers.name,
      snowflake_role.analysts.name
    ]

  on_future = true
}

resource "snowflake_table_grant" "database_raw_stitch_table_grant_w" {
  provider = snowflake.security_admin
  for_each = toset(local.table_write_privileges)

  database_name = snowflake_database.database_raw_stitch.name

  privilege = each.value
  roles     = [
      "SYSADMIN",
      snowflake_role.role_sv_stitch.name
    ]

  on_future = true
}
