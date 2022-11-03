.PHONY: build clean install-hugo serve serve-dev

# by default, .Rmd does not get rendered - previously generated md/html from .Rmd is used instead
build: clean
	Rscript utils/build.R

clean:
	rm -rf public

install-hugo:
	Rscript utils/install-hugo.R

# serves html output from built hugo site directory (e.g. public/)
# refreshes on new content
serve:
	Rscript utils/serve.R

# rebuilds hugo source (.md) on save 
# and also .Rmd if `blogdown.knit.on_save` option is set to `TRUE`
# option is set in .Rprofile
serve-dev:
	Rscript utils/serve-dev.R
