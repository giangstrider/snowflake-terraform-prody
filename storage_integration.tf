resource "snowflake_storage_integration" "integration_aws_analytics_prod" {
  name    = "AWS_ANALYTICS_PROD"
  comment = "Storage integration production for #${local.aws_account_prod}"
  type    = "EXTERNAL_STAGE"
  enabled = true

  storage_provider = "S3"  
  storage_allowed_locations = [
      "s3://bucket-1-ap-southeast-2/",
      "s3://bucket-2-ap-southeast-2/"
  ]
  storage_aws_object_acl    = "bucket-owner-full-control"
  storage_aws_role_arn      = "arn:aws:iam::${local.aws_account_prod}:role/analytics-snowflake-prod"
}
