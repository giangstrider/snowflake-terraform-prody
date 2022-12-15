// ==========================================
// SYSADMIN - ROLE HIERACHY
// ==========================================
// PRIVILLEGE FOR SV_CICD_PIPELINE-SYSADMIN TO CREATE STORAGE INTEGRATTION ONLY
GRANT CREATE INTEGRATION,
CREATE SHARE
ON ACCOUNT TO ROLE SYSADMIN;


// ==========================================
// Service CI/CD
// ==========================================
// Creation for Terraforming Snowflake
CREATE OR REPLACE USER "SV_CICD_PIPELINE" 
PASSWORD='placeholder'
DEFAULT_ROLE=PUBLIC 
DEFAULT_WAREHOUSE=COMPUTE_WH
MUST_CHANGE_PASSWORD=TRUE;

GRANT ROLE SYSADMIN TO USER "SV_CICD_PIPELINE";
GRANT ROLE SECURITYADMIN TO USER "SV_CICD_PIPELINE";

alter user SV_CICD_PIPELINE set mins_to_unlock= 0;

create role orgadmin;
SHOW GRANTS OF ROLE "ORGADMIN";

grant role orgadmin to user YOUR_FIRST_USER_PROVIDED_BY_SNOWFLAKE;