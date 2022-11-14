library(arrow)
library(countrycode)
library(DBI)
library(data.table)
library(dataRetrieval)
library(dplyr)
library(duckdb)

## FIPS - Everything outside of the 'US' ----
# ~1 second & 35 countries
d_cc <- data.table(countrycode::codelist)
cc_fips <- sort(unique(d_cc$fips))
cc_fips_no_us <- cc_fips[! cc_fips == "US"]
tic()
d_wqp_fips_cc <- data.table(
  whatWQPsites(countrycode = cc_fips_no_us)
)
toc()

for(i in 1:d_wqp_fips_cc[1:2, .N]) {
  arrow::write_dataset(
    dataset = d_wqp_fips_cc[i] |> group_by(MonitoringLocationIdentifier),
    path = "./data/lake",
    existing_data_behavior = "delete_matching" #"overwrite" "delete_matching" "error"
  )
}

ds_lake <- arrow::open_dataset(
  sources = "./data/lake/"
)

d_lake <- ds_lake |> collect() |> setDT()
