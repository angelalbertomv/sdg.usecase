terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.22.0"
    }
  }
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

locals {
  warehouse_name = "COMPUTE_WH"
}

resource "snowflake_database" "db" {
  name = "TF_USECASE"
}

resource "snowflake_role" "role" {
  name = "TF_DEMO_SDG_ROLE"
}

resource "snowflake_database_grant" "grant" {
  database_name     = snowflake_database.db.name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.db.name
  name       = "TF_DEMO"
  is_managed = false
}

resource "snowflake_schema_grant" "grant" {
  database_name     = snowflake_database.db.name
  schema_name       = snowflake_schema.schema.name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
}

resource "snowflake_warehouse_grant" "grant" {
  warehouse_name    = locals.warehouse_name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
}

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "user" {
  name              = "tf_demo_user"
  default_warehouse = locals.warehouse_name
  default_role      = snowflake_role.role.name
  default_namespace = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "snowflake_role_grants" "grants" {
  role_name = snowflake_role.role.name
  users     = [snowflake_user.user.name]
}