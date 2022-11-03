# serves site - takes input to `servr::server_config`
# rebuilds hugo source (.md) on save 
# and also .Rmd if `blogdown.knit.on_save` option is set to `TRUE`
# option is set in .Rprofile
blogdown::serve_site()