TOC_DEPTH=3

MD_SOURCES=$(shell find . -name '*.md' -not -path "./templates/*")
HTML_TARGETS=$(MD_SOURCES:%.md=build/%.html)
PDF_TARGETS=$(MD_SOURCES:%.md=build/%.pdf)

DOT_SOURCES=$(shell find . -name '*.dot' -not -path "./templates/*")
DOT_TARGETS=$(DOT_SOURCES:%.dot=build/%.png)

TEX_SOURCES=$(shell find . -not -path "./templates/*" -name '*.tex')
TEX_TARGETS=$(TEX_SOURCES:%.tex=build/%.pdf)

COMPRESS_TARGETS=$(HTML_TARGETS:%=%.gz)
COMPRESS_TARGETS+=$(TEX_TARGETS:%=%.gz)

.PHONY: default
default: html pdf

.PHONY: pdf
pdf: dot $(PDF_TARGETS)

.PHONY: html
html: dot $(HTML_TARGETS)

.PHONY: dot
dot: $(DOT_TARGETS)

.PHONY: compress
compress: default $(COMPRESS_TARGETS)

build/%.html: %.md
	@mkdir -p $$(dirname $@)
	pandoc -s --mathjax --template ./templates/mindoc.html --toc --toc-depth=$(TOC_DEPTH) -o $@  $<

build/%.pdf: %.md
	@mkdir -p $$(dirname $@)
	pandoc --resource-path=$$(dirname $@) --template ./templates/eisvogel.tex --toc --toc-depth=$(TOC_DEPTH) -o $@  $<

.PHONY: clean
clean:
	rm -r build
