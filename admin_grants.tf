# ==========================================
# [IMPORTANT] SYSADMIN - Grant to user
# THIS SECTION GRANT ACCOUNTADMIN/SYSADMIN
# WHO MANAGES ENTIRED SNOWFLAKE PLATFORM
# ==========================================
# REMEMBER: when run TF plan after sysadmin left, let delete the grant before apply.

resource "snowflake_role_grants" "grant_sysadmins_to_sso_user" {
  provider = snowflake.security_admin
  for_each = toset([
    "ACCOUNTADMIN", "SYSADMIN", "SECURITYADMIN", "USERADMIN"
  ])

  role_name = each.value
  users = [
    for role in setintersection(
      toset([for role in snowflake_role.brighte_user_role : role.name]),
      toset(local.sysadmins)
    ):
    replace("${role}@YOUR_ORG.COM", "_", ".") # This is demonstrate for SSO user.
  ]
}

# =============END IMPORTANT================