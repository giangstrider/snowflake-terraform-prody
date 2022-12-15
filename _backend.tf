terraform {
  backend "s3" {
    key            = "snowflake/terraform"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}