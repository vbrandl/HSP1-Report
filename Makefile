TOC_DEPTH=3

MD_SOURCES=$(shell find . -name '*.md' -not -path "./templates/*")
HTML_TARGETS=$(MD_SOURCES:%.md=build/%.html)
PDF_TARGETS=$(MD_SOURCES:%.md=build/%.pdf)

DOT_SOURCES=$(shell find . -name '*.dot' -not -path "./templates/*")
DOT_TARGETS=$(DOT_SOURCES:%.dot=build/%.svg)

TEX_SOURCES=$(shell find . -not -path "./templates/*" -not -path "./equations/*" -name '*.tex')
TEX_TARGETS=$(TEX_SOURCES:%.tex=build/%.pdf)

EQ_SOURCES=$(shell find ./equations/ -name '*.tex')
EQ_TARGETS=$(EQ_SOURCES:./equations/%.tex=build/%.svg)

COMPRESS_TARGETS=$(HTML_TARGETS:%=%.gz)
COMPRESS_TARGETS+=$(TEX_TARGETS:%=%.gz)

.PHONY: default
default: html # pdf

.PHONY: pdf
pdf: dot $(PDF_TARGETS)

.PHONY: equations
equations: $(EQ_TARGETS)

.PHONY: html
html: dot equations $(HTML_TARGETS)

.PHONY: dot
dot: $(DOT_TARGETS)

.PHONY: compress
compress: default $(COMPRESS_TARGETS)

build/%.html: %.md
	@mkdir -p $$(dirname $@)
	pandoc --self-contained -s --mathjax --template ./templates/mindoc.html --toc --toc-depth=$(TOC_DEPTH) -o $@  $<

build/%.pdf: %.md
	@mkdir -p $$(dirname $@)
	pandoc --resource-path=$$(dirname $@) --template ./templates/eisvogel.tex --toc --toc-depth=$(TOC_DEPTH) -o $@  $<

build/%.svg: ./equations/%.tex
	@mkdir -p $$(dirname $@)
	latexmk -pdf -output-directory="./build/" $<
	pdfcrop "$(basename $@).pdf" "$(basename $@).pdf"
	pdf2svg "$(basename $@).pdf" "$(basename $@).svg"

build/%.svg: %.dot
	@mkdir -p $$(dirname $@)
	dot -Tsvg -o $@ $<

.PHONY: clean
clean:
	rm -r build
