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


## How to use
Before running with Terraform, an extra step need to do manually in order to provides terraform appropriate access to execute resources.
- Run script in `pre_terraform.sql`
### Config
#### `_variables.tf`

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

#### `admin_grant.tf`
Line 20:
```
replace("${role}@YOUR_ORG.COM", "_", ".") # This is demonstrate for SSO user.
```
Change your organisation domain here.

#### `role_grants.tf`
Search for `YOUR_ORG.COM` and do similar to `admin_grant.tf`

### Work with your terraform
- You can just simply clone this project and make this as a module/sub-module of your terraform project, depending how your terraform is organised. And then start to modify to fit your needs.
- Or just simply copy content each of file as your needs and place in your terraform project.

### Note
Please review each of your terraform creation carefully as this template contain many examples object only.
This template uses many advance terraform concept to deal with Snowflake's Terraform bug so please raise issue if you're not understand.