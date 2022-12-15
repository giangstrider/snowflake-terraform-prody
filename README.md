# Snowflake Terraform production ready
An implementation for deploying Snowflake by Terraform, within seconds with ready CICD pipeline for production run.

This implementation provides:
- Managing Snowflake permission hierrachy. Inspired by [Gitlab's Snowflake permission paradigm](https://about.gitlab.com/handbook/business-technology/data-team/platform/#snowflake-permissions-paradigm) which open-sourced by project call [Permifrost](https://gitlab.com/gitlab-data/permifrost).
- Coping with AWS S3 Stage for Snowflake, you can refer to AWS Terraform resources as well.
- By using official Snowflake's terraform plugin, it is fully compatible with anything within the library.
- Coping above paradigm with SSO Group user provisioned by AD Group.

## Idea
Divide your users to 3 main groups:
    - Admin: i.e person who manage `ACCOUNTADMIN`, `SYSADMIN` role
    - Engineer: who works with Snowflake on daily basis like create databases, tables, pipelines.
    - Analyst: who mostly work with select query.
The list goes on, but 3 main groups is the core of the idea.

Secondly, with each Snowflake objects, we divided it into level of privileges. Ie. Read only, Read-Write, Third-party-account type.
With this definition, any new objects being created will need to be got the right level before provisioning. And later on, follow this pattern for any object creation. You can modify the type of permission granting for each of level according to your needs.


## General config
Refer to `_variables.tf`

```
sysadmins = ["GIANGSTRIDER", "YOUR_ENGINEER_NAME"] # 1st level
data_engineers = ["ENGINEER_NAME_1", "ENGINEER_NAME_2] # 2nd level
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
```