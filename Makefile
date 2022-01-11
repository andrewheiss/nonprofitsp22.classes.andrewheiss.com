OUTPUTDIR=public
SSH_TARGET=cloud:/home/andrew/sites/nonprofitsp22.classes/public_html

.PHONY : all clean serve build deploy zip_projects pdf_slides

all: build pdf_slides


# Slides to PDF -----------------------------------------------------------
TO_PDF = $(wildcard static/slides/*.html)
PDF_TARGETS = $(addsuffix .pdf,$(basename $(TO_PDF)))

static/slides/%.pdf: static/slides/%.html
	Rscript R/pdfize.R $@

pdf_slides: $(PDF_TARGETS)


# Site building -----------------------------------------------------------
clean:
	rm -rf public/

static/slides/css/ath-slides.css:
	sass static/slides/css/ath-slides.scss > static/slides/css/ath-slides.css

# build: 
#build: static/slides/css/ath-slides.css pdf_slides
build: pdf_slides
	Rscript -e "blogdown::build_site(build_rmd = blogdown::filter_md5sum)"

serve: build
	Rscript -e "blogdown::serve_site(port=4321)"

deploy: build
	rsync -Prvzc --exclude='.DS_Store' --exclude='.Rproj.user/' --delete $(OUTPUTDIR)/ $(SSH_TARGET)
