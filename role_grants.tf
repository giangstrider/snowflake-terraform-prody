# ==========================================
# SYSADMIN - ROLE HIERACHY
# ==========================================
resource "snowflake_role_grants" "sysadmin_grants" {
  provider = snowflake.security_admin

  for_each = toset(
    concat(
        [
          snowflake_role.role_data_engineers.name,
          snowflake_role.role_analyts.name,
          snowflake_role.role_sv_airflow.name,
          snowflake_role.role_sv_stitch.name,
          # Dev
          snowflake_role.role_dev_sv_airflow.name
        ],
        [for role in snowflake_role.org_user_role : role.name]
    )
)
  role_name = each.value
  roles = ["SYSADMIN"]
}


# ==========================================
# SERVICE ROLES
# ==========================================
resource "snowflake_role_grants" "sv_airflow_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_sv_airflow.name
  users = concat(
    #[for role in snowflake_role.brighte_user_sysadmin_role : role.name],
    [snowflake_user.user_sv_airflow.name]
  )
}

resource "snowflake_role_grants" "dev_sv_airflow_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_dev_sv_airflow.name
  users = concat(
    #[for role in snowflake_role.brighte_user_sysadmin_role : role.name],
    [snowflake_user.user_dev_sv_airflow.name]
  )
}

resource "snowflake_role_grants" "sv_stitch_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_sv_stitch.name
  users = concat(
    #[for role in snowflake_role.brighte_user_sysadmin_role : role.name],
    [snowflake_user.user_sv_stitch.name]
  )
}


# ==========================================
# USER ROLES
# ==========================================
### NOTE: create_before_destroy is to prevent org_user_role to be destroyed
###       before these grants are being update-in-place
resource "snowflake_role_grants" "data_engineer_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_data_engineers.name

  roles = setintersection(
    toset([for role in snowflake_role.org_user_role : role.name]),
    toset(concat(local.sysadmins, local.data_engineers))
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "snowflake_role_grants" "spoke_developer_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_analyts.name

  roles = setintersection(
    toset([for role in snowflake_role.org_user_role : role.name]),
    toset(concat(local.sysadmins, local.data_engineers, local.analysts))
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ==========================================
# SSO USER ROLES
# ==========================================
# User SSO mapping with role respectively
resource "snowflake_role_grants" "user_sso_role_mapping_grants" {
  provider = snowflake.security_admin
  for_each = toset([for role in snowflake_role.org_user_role : role.name])

  role_name = each.value
  users = [replace("${each.value}@YOUR_ORG.COM", "_", ".")]

  lifecycle {
    create_before_destroy = true
  }
}

resource "snowflake_role_grants" "general_role_grants" {
  provider = snowflake.security_admin

  role_name = snowflake_role.role_general.name
  users = [for role in snowflake_role.org_user_role : replace("${role.name}@YOUR_ORG.COM", "_", ".")]

  lifecycle {
    create_before_destroy = true
  }
}
