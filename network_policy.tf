resource "snowflake_network_policy" "network_policy_stitch" {
  provider = snowflake.security_admin

  name    = "STITCH_POLICY"
  comment = "[User Level] ${snowflake_user.user_sv_stitch.name}"

  allowed_ip_list = ["52.23.137.21", "52.204.223.208", "52.204.228.32", "52.204.230.227"]
}
