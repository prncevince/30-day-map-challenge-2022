library(arrow)
library(data.table)
library(dplyr)

for(i in 1:d_wqp_cc_na[1:2, .N]) {
  arrow::write_dataset(
    dataset = d_wqp_cc_na[i],
    path = "./data/lake",
    existing_data_behavior = "error"
  )
}

ds_lake <- arrow::open_dataset(
  sources = "./data/lake/"
)

d_lake <- ds_lake |> collect() |> setDT()
