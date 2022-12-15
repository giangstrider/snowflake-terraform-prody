# ==========================================
# Database
# ==========================================
resource "snowflake_database" "database_raw" {
  name                        = "RAW"
  comment                     = "Data in raw format which pull from different sources"
  data_retention_time_in_days = 30
}

resource "snowflake_database_grant" "database_raw_grant_rw" {
  provider = snowflake.security_admin
  for_each = toset(concat(local.database_read_privileges, local.database_write_privileges))

  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_airflow.name,
    snowflake_role.data_engineers.name,
    snowflake_role.analysts.name
  ]
}

# ==========================================
# Schema
# ==========================================
# General grant
resource "snowflake_schema_grant" "database_raw_schema_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.schema_read_privileges)
  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_airflow.name,
    snowflake_role.data_engineers.name,
    snowflake_role.analysts.name
]
  on_future = true
}

# General grant
resource "snowflake_schema_grant" "database_raw_schema_grant_w" {
  provider = snowflake.security_admin
  for_each = toset(local.schema_write_privileges)

  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
    "SYSADMIN",
    snowflake_role.role_sv_airflow.name
  ]
  on_future = true
}

resource "snowflake_schema" "database_raw_schema_demo" {
  database = snowflake_database.database_raw.name
  name     = "demo"
  comment  = "Demo schema"

  is_transient        = false
  is_managed          = false
  data_retention_days = 7

  depends_on = [
    snowflake_schema_grant.database_raw_schema_grant_r,
    snowflake_schema_grant.database_raw_schema_grant_w
  ]
}

# ==========================================
# 3rd parties explicitly created schema
# ==========================================
### Note: depends_on for the schema creation below
###     Because snowflake_schema_grant with on_future option being created in the same
###     time with schema creation, so high chance schema will be missed grant inherit by on_future
resource "snowflake_schema" "database_raw_schema_salesforce" {
  database = snowflake_database.database_raw.name
  name     = "saleforces"

  is_transient        = false
  is_managed          = false
  data_retention_days = 7

  depends_on = [
    snowflake_schema_grant.database_raw_schema_grant_r,
    snowflake_schema_grant.database_raw_schema_grant_w
  ]
}

resource "snowflake_schema_grant" "database_raw_schema_salesforce_grant_rw" {
  provider = snowflake.security_admin
  for_each = toset(concat(local.schema_read_privileges, local.schema_write_privileges))

  database_name = snowflake_database.database_raw.name
  schema_name = snowflake_schema.database_raw_schema_salesforce.name

  privilege = each.value
  roles     = [snowflake_role.role_sv_salesforce.name]

  # Let not Terraform detect on_future grant as an outside action
  enable_multiple_grants = true
}


# ==========================================
# Table
# ==========================================
# Everyone can read
resource "snowflake_table_grant" "database_raw_table_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.table_read_privileges)

  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
      "SYSADMIN",
      snowflake_role.role_sv_airflow.name,
      snowflake_role.data_engineers.name,
      snowflake_role.analysts.name
    ]

  on_future = true
}

# Online auto-scheduled role can write
resource "snowflake_table_grant" "database_raw_schema_contain_tables_grant_w" {
  provider = snowflake.security_admin
  for_each = toset(local.table_write_privileges)

  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
      "SYSADMIN",
      snowflake_role.role_sv_airflow.name
    ]

  on_future = true
}


# ==========================================
# View
# ==========================================
resource "snowflake_view_grant" "database_raw_view_grant_r" {
  provider = snowflake.security_admin
  for_each = toset(local.view_read_privileges)

  database_name = snowflake_database.database_raw.name

  privilege = each.value
  roles     = [
      "SYSADMIN",
      snowflake_role.role_sv_airflow.name,
      snowflake_role.data_engineers.name,
      snowflake_role.analysts.name
    ]

  on_future = true
}
