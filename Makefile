.PHONY: build serve serve-dev

build:
	Rscript utils/build.R

serve:
	Rscript utils/serve.R

serve-dev:
	Rscript utils/serve-dev.R