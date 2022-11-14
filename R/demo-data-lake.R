library(arrow)
library(countrycode)
library(DBI)
library(data.table)
library(dataRetrieval)
library(dplyr)
library(duckdb)

# FIPS - Everything outside of the 'US' ----
# ~1 second & 35 countries
d_cc <- data.table(countrycode::codelist)
cc_fips <- sort(unique(d_cc$fips))
cc_fips_no_us <- cc_fips[! cc_fips == "US"]
tic()
d_wqp_fips_cc <- data.table(
  whatWQPsites(countrycode = cc_fips_no_us)
)
toc()

# globals ----
db_table <- "sites"
db_path <- "./data/base"
dlake_path <- "./data/lake"

# arrow dataset datalake initialization ----
dir.create(path = dlake_path)

# duckDB database initialization ----
dir.create(path = dlake_path)
con = dbConnect(drv = duckdb::duckdb(), dbdir ="data/base/site.duckdb", read_only = FALSE)

# ETL ----
for(i in 1:d_wqp_fips_cc[1:2, .N]) {
  ## arrow datalake ----
  arrow::write_dataset(
    dataset = d_wqp_fips_cc[i] |> group_by(MonitoringLocationIdentifier),
    path = dlake_path,
    existing_data_behavior = "delete_matching" #"overwrite" "delete_matching" "error"
  )
  ## duckdb database ----
  # insert statements in a loop - which is NOT recommended by duckDB:
  # https://duckdb.org/docs/data/insert
  duckdb::dbWriteTable(
    conn = con,
    name = db_table, value = d_wqp_fips_cc[i],
    append = TRUE
  )
}
## duckdb database FROM parquet datalake ----
dbExecute(
  conn = con, 
  statement = sprintf(
    "CREATE TABLE %s AS SELECT * FROM read_parquet(['%s/**/*.parquet'])",
    db_table, dlake_path
  )
)
# "CREATE TABLE sites AS SELECT * FROM read_parquet(['./data/lake/**/*.parquet'])",

# -- use a list of globs to read all parquet files from 2 specific folders
# SELECT * FROM read_parquet(['folder1/*.parquet','folder2/*.parquet']);
# -- create a table directly from a parquet file
# CREATE TABLE people AS SELECT * FROM read_parquet('test.parquet');

# query results ----
## arrow datalake ----
ds_lake <- arrow::open_dataset(
  sources = "./data/lake/"
)
d_lake <- ds_lake |> collect() |> setDT()
## duckdb database ----
d_sites <- dbReadTable(conn = con, name = "sites") |> setDT()

# shutdown database connection ----
dbDisconnect(conn = con, shutdown=TRUE)
