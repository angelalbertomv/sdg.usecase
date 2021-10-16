terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.22"
    }
  }
}

provider "snowflake" {
  alias = "sys_admin"
  role  = "SYSADMIN"
}

locals {
  warehouse_name = "COMPUTE_WH"
  schema_name    = "SDG_USECASE"
  database_name  = "SDG_DB"
  table_name     = "adl_sdgtestcase"
}

resource "snowflake_database" "db" {
  name = local.database_name
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.db.name
  name       = local.schema_name
  is_managed = false
}

resource "snowflake_sequence" "sequence" {
  database = snowflake_schema.schema.database
  schema   = snowflake_schema.schema.name
  name     = "sequence"
}

resource "snowflake_table" "table" {
  database        = snowflake_schema.db.database
  schema          = snowflake_schema.schema.name
  name            = local.table_name
  comment         = "SDG TEST CASE"
  cluster_by      = ["to_date(DATE)"]
  change_tracking = false

  column {
    name     = "LOAD_ID"
    type     = "int"
    nullable = true

    default {
      sequence = snowflake_sequence.sequence.fully_qualified_name
    }
  }

  column {
    name     = "BUSINESS_ID"
    type     = "text"
    nullable = false
  }

  column {
    name = "LOAD_DATE"
    type = "TIMESTAMP_NTZ(9)"
    default {
      expresion = current_timestamp()
    }
  }

  column {
    name    = "PAYLOAD"
    type    = "VARIANT"
    comment = "extra data"
  }

  primary_key {
    name = "my_key"
    keys = ["LOAD_ID"]
  }
}