# serves site - takes input to `servr::server_config`
# Rebuilds hugo source (.md & .Rmd) on save if `blogdown.knit.on_save` option is set to `TRUE`
# set in .Rprofile
blogdown::serve_site()