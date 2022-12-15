terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.47.0"
    }
  }
}


# Configure the Snowflake Provider
provider "snowflake" {
  account  = var.SNOWFLAKE_ACCOUNT
  region   = var.SNOWFLAKE_REGION
  username = var.SNOWFLAKE_USERNAME
  password = var.SNOWFLAKE_PASSWORD
  role     = "SYSADMIN"
}

provider "snowflake" {
  alias  = "account_admin"

  account  = var.SNOWFLAKE_ACCOUNT
  region   = var.SNOWFLAKE_REGION
  username = var.SNOWFLAKE_USERNAME
  password = var.SNOWFLAKE_PASSWORD
  role     = "ACCOUNTADMIN"
}

provider "snowflake" {
  alias  = "security_admin"

  account  = var.SNOWFLAKE_ACCOUNT
  region   = var.SNOWFLAKE_REGION
  username = var.SNOWFLAKE_USERNAME
  password = var.SNOWFLAKE_PASSWORD
  role     = "SECURITYADMIN"
}
