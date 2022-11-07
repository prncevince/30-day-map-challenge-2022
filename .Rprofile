if (system("uname", intern = T) == "Linux") {
  # when working on Linux & not using GitHub Actions (e.g. RStudio Cloud)
  if (is.na(Sys.getenv("RENV_CONFIG_REPOS_OVERRIDE", unset = NA))) {
    Sys.setenv(RENV_CONFIG_REPOS_OVERRIDE="https://packagemanager.rstudio.com/all/__linux__/focal/latest")
  }
}
source("renv/activate.R")

options(
  # fix Hugo version
  blogdown.hugo.version = "0.105.0",
  # to automatically serve the site on RStudio startup, set this option to TRUE
  blogdown.serve_site.startup = FALSE,
  # to disable knitting Rmd files on save, set this option to FALSE
  blogdown.knit.on_save = TRUE,
  # build .Rmd to .html (via Pandoc); to build to Markdown, set this option to 'markdown'
  blogdown.method = 'html',
  # this is necessary for running `blogdown::serve_site()` e.g. `make serve-dev` b/c 
  # blogdown::serve_site() is messed up - doesn't seem to work correctly
  # you need to navigate to localhost:xxxx manually
  # hugo server -D -F --navigateToChanged
  blogdown.hugo.server = c('-D', '-F', '--navigateToChanged', '--baseURL ', 'http://127.0.0.1'),
  # blogdown.hugo.server = c('-D', '-F', '--navigateToChanged', '--baseURL ', '127.0.0.1/30-day-map-challenge-2022'),
  # Suppress warnings when !expr values are in R Markdown yaml header
  yaml.eval.expr = TRUE
)
