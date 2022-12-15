##
## Environment Variables
##

variable "SNOWFLAKE_ACCOUNT" {
  type        = string
  description = "The Snowflake account identifier"
}

variable "SNOWFLAKE_REGION" {
  type        = string
  description = "The Snowflake region the account resides in"
}


variable "SNOWFLAKE_USERNAME" {
  type        = string
  description = "The Snowflake username to authenticate with"
}

variable "SNOWFLAKE_PASSWORD" {
  type        = string
  description = "The Snowflake password to authenticate with"
  sensitive   = true
}

##
## Local/Workspace Variables
##

locals {
  sysadmins = ["GIANGSTRIDER", "YOUR_ENGINEER_NAME"] # 1st level
  data_engineers = ["ENGINEER_NAME_1", "ENGINEER_NAME_2"] # 2nd level
  analysts = ["ANALYST_1", "ANALYST_2", "ANALYST_3"] #3nd level

  database_read_privileges = ["USAGE"]
  database_write_privileges = ["MONITOR"]
  database_third_party_ingestion_privileges = ["MODIFY", "CREATE SCHEMA"]
  schema_read_privileges = ["USAGE", "MONITOR"]
  schema_write_privileges = ["CREATE TABLE", "CREATE VIEW", "CREATE SEQUENCE", "CREATE FUNCTION", "CREATE PROCEDURE"]
  schema_owner_privileges = ["OWNERSHIP"]
  table_read_privileges = ["SELECT"]
  table_write_privileges = ["INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES"]
  view_read_privileges = ["SELECT", "REFERENCES"]
  warehouse_read_privileges = ["MONITOR"]
  warehouse_usage_privileges = ["USAGE"]
  warehouse_write_privileges = ["MODIFY", "OPERATE"]
  external_stage_read_privileges = ["USAGE", "READ"]

  aws_account_staging = "0123456789"
  aws_account_prod = "9876543210"
}
