# by default, .Rmd does not get rendered - previously generated md/html from .Rmd is used instead
# to rebuild .Rmd run:
# blogdown::build_site(build_rmd = T)
# unfortunately, .Site.BaseURL & .Permalink get messed up by blogdown::build_site
# honestly, nothing that RStudio did here really makes sense ... 
# like at all ‾\_0_o_/‾ ... I guess that's why they made https://quarto.org/docs/websites/
# run in order: ----
## Renders Rmd to hugo compatible html ----
blogdown::build_site(run_hugo = F)
## Runs hugo to build site ----
# takes CLI arguments to hugo
args <- commandArgs(trailingOnly = TRUE)[-1]
xfun::system3(blogdown::find_hugo(), args)