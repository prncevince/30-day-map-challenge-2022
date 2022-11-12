library(dataRetrieval)
library(data.table)
library(countrycode)
library(tictoc)

# unique site ID: `MonitoringLocationIdentifier`

# ~18 seconds
tic()
d_wqp_wi_phos <- data.table(
  whatWQPsites(statecode = "WI"), characteristicName = "Phosphorus"
)
toc()

# ~27 seconds
tic()
d_wqp_wi <- data.table(
  whatWQPsites(statecode = "WI")
)
toc()

# similar 
# OrganizationIdentifier
# A designator used to uniquely identify a unique business establishment within a context.
d_wqp_wi[, 
  MonitoringLocationIdentifier |> strsplit(split = "-") |> lapply(`[`, 1) |> 
    unlist() |> unique() |> sort()
]
d_wqp_wi[, sort(unique(OrganizationIdentifier))]

# by `countrycode`
d_cc <- data.table(countrycode::codelist)



# Puerto Rico
tic()
d_wqp_rq <- data.table(
  whatWQPsites(countrycode = "RQ")
)
toc()

# Everything outside of the 'US'
# ~1 second & 35 countries
cc_fips <- sort(unique(d_cc$fips))
cc_fips_no_us <- cc_fips[! cc_fips == "US"]
tic()
d_wqp_cc <- data.table(
  whatWQPsites(countrycode = cc_fips_no_us)
)
toc()

merge.data.table(
  by.x = c("fips"), by.y = c("CountryCode"),
  x = d_cc[fips %in% d_wqp_cc[,unique(CountryCode)], .(country.name.en, fips)],
  y = d_wqp_cc[, .N, by = CountryCode]
)[order(N, decreasing = T)]
d_wqp_cc[, .N, by = CountryCode][order(N, decreasing = T)]
d_cc[fips %in% d_wqp_cc[,unique(CountryCode)], .(country.name.en, fips)]

# All of the 'US'
# ~7.5 minutes & ~2.7 million sites
tic()
d_wqp_cc_us <- data.table(
  whatWQPsites(countrycode = "US")
)
toc()

# No CountryCode data ...
# ~7.5 minutes & ~2.7 million sites
tic()
d_wqp_cc_us <- data.table(
  whatWQPsites(countrycode = NA)
)
toc()

# summaries ----
## counts by `MonitoringLocationIdentifier`  ----
d_wqp_cc_us[, length(unique(MonitoringLocationIdentifier))]
dim(d_wqp_cc_us)
## `OrganizationIdentifier` & unique partial `MonitoringLocationIdentifier` ----
### countries ----
cc_OrganizationIdentifier <- d_wqp_cc[, sort(unique(OrganizationIdentifier))]
cc_MonitoringLocationIdentifier_part <- d_wqp_cc[,
  MonitoringLocationIdentifier |> strsplit(split = "-") |> lapply(`[`, 1) |> 
    unlist() |> unique() |> sort()
]
cc_OrganizationIdentifier[!cc_OrganizationIdentifier %in% cc_MonitoringLocationIdentifier_part]
# all 'USGS-*' IDs 
cc_MonitoringLocationIdentifier_part[!cc_MonitoringLocationIdentifier_part %in% cc_OrganizationIdentifier]
# [1] "CAX01" "RQ025" "USAID" "USGS" 
### united states ----
us_OrganizationIdentifier <- d_wqp_cc_us[, sort(unique(OrganizationIdentifier))]
us_MonitoringLocationIdentifier_part <- d_wqp_cc_us[, 
  MonitoringLocationIdentifier |> strsplit(split = "-") |> lapply(`[`, 1) |> 
    unlist() |> unique() |> sort()
]
us_OrganizationIdentifier[!us_OrganizationIdentifier %in% us_MonitoringLocationIdentifier_part]
# all 'USGS-*' IDs 
# [1] "AK-CHIN_WQX" "ALS-SJ" "CFE-STS" "CSR_EPA_CWA-106" "CSU-CIVIL&ENVIRONMENTAL-ENG" "IEC-NYNJCT"
# [7] "OKWRB-LAKES_WQX" "OKWRB-STREAMS_WQX" "SC-NJ" "USACE-STL-EC-E" "USBR-WCAO"
us_MonitoringLocationIdentifier_part[!us_MonitoringLocationIdentifier_part %in% us_OrganizationIdentifier]
#   [1] "AK"     "AL012" "AR001" "AR008"      "AR025" "AZ003" "AZ008" "AZ009" "AZ011"  "AZ014" 
#  [11] "AZ021" "CA001" "CFE"   "CSR_EP_CWA" "CSU"   "DE002" "DMI"   "FL005" "FL051"  "FL129" 
#  [21] "GA009" "IA021" "ID001" "ID003"      "ID004" "IEC"   "IL004" "IN002" "IN014"  "IN015" 
#  [31] "IN021" "IN032" "IN033" "IN039"      "IN040" "IN041" "IN042" "KS003" "KS009"  "KS014" 
#  [41] "KY001" "LA014" "LA018" "MA035"      "MD006" "MD007" "MD058" "MI001" "MN003"  "MN019" 
#  [51] "MN040" "MN048" "MO005" "ND002"      "NH021" "NM004" "NV001" "NV012" "NV052"  "NV083" 
#  [61] "NV087" "NY001" "OH004" "OH015"      "OK002" "OK003" "OK005" "OKWRB" "OR004"  "PA001" 
#  [71] "RQ020" "SC"    "SC004" "SC008"      "TX001" "TX003" "TX071" "USA"   "USACE"  "USARS" 
#  [81] "USBIA" "USBLM" "USBR"  "USCE"       "USDA"  "USDOE" "USEPA" "USFS"  "USFWS"  "USGS"  
#  [91] "USIBW" "USN"   "USNOA" "USNOS"      "USNPS" "USNWS" "USSCS" "VA087" "VT004"  "VT012" 
# [101] "WA013" "WI009" "WV001" "WV002" 
# counts by partials of `MonitoringLocationIdentifier`
d_wqp_cc[,
  MonitoringLocationIdentifier |> strsplit(split = "-") |> lapply(length) |> 
    unlist() |> table()
]
#    2    3    4    5 
# 1273 1127   77    8 
d_wqp_cc_us[,
  MonitoringLocationIdentifier |> strsplit(split = "-") |> lapply(length) |> 
    unlist() |> table()
]
#       2       3       4       5       6       7 
# 2414303  197324   46348   37492    2526      17 
# counts by `ProviderName`
d_wqp_cc[, .N, by = ProviderName][order(N, decreasing = T)]
d_wqp_cc_us[, .N, by = ProviderName][order(N, decreasing = T)]


d_wqp_cc_us[ProviderName == "STEWARDS"][,.(MonitoringLocationIdentifier, OrganizationIdentifier, OrganizationFormalName, MonitoringLocationName, MonitoringLocationTypeName)]
