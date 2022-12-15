resource "snowflake_role" "role_sv_airflow" {
  provider = snowflake.security_admin

  name    = "SV_AIRFLOW"
  comment = "Airflow role for operation interact with platform"
}

resource "snowflake_role" "role_sv_stitch" {
  provider = snowflake.security_admin

  name    = "SV_STITCH"
  comment = "Stitch role for data integration"
}
