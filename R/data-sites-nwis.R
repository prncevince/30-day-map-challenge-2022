library(dataRetrieval)
library(data.table)
library(tictoc)

# no more than 25 degree product of lat/lon
"//waterservices.usgs.gov/nwis/site/?format=rdb&bBox=-180.000000,-90.000000,-175.000000,-85.000000&siteStatus=all"
# the whole world
"//waterservices.usgs.gov/nwis/site/?format=rdb&bBox=-180.000000,180.000000,-90.000000,90.000000&siteStatus=all"

tic()
d_site_oh <- whatNWISsites(stateCd="OH")
toc()

# cannot query multiple states at the same time
# does not pass dataRetrieval:::readNWISdots
# d_nwis_all_states <- whatNWISsites(
#   stateCd = stateCd
# )

# cannot query states not in dataRetrieval:::stateCdLookup
# tic()
# d_site_yt <- whatNWISsites(stateCd="YT")
# toc()

tic(msg = "All 'States'")
stateCd <- sort(unique(dataRetrieval::stateCd$STUSAB))
d_nwis_all_states <- data.table()
for (s in stateCd) {
  tic(msg = s)
  d_nwis_all_states <- rbind(
    d_nwis_all_states,
    cbind(whatNWISsites(stateCd = s), stateCd = s)
  )
  toc()
}
toc()

# summaries ----
## counts by state ----
d_nwis_all_states[, .N, by = stateCd][order(N, decreasing = T)]
## counts by categories ----
### site_tp_cd ----
d_nwis_all_states[, .N, by = site_tp_cd][order(N, decreasing = T)]
### agency_cd ----
d_nwis_all_states[, .N, by = agency_cd][order(N, decreasing = T)]
### colocated ----
d_nwis_all_states[, .N, by = colocated]
### duplicate sites ----
d_nwis_all_states[duplicated(site_no),]
### unique station names ----
d_nwis_all_states[, length(unique(station_nm))]
