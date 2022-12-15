resource "snowflake_role" "role_data_engineer" {
  provider = snowflake.security_admin
  name    = "data_engineer"
  comment = "Hub engineer team to perform daily operation of platform"
}

resource "snowflake_role" "role_analyst" {
  provider = snowflake.security_admin
  name    = "analyst"
  comment = "Spoke developer interacting with dbt models"
}

resource "snowflake_role" "org_user_role" {
  provider = snowflake.security_admin

  for_each  = toset(concat(
    local.sysadmins, local.data_engineers, local.analysts
    ))

  name    =  each.value
  comment = "User role of ${each.value}"
}
