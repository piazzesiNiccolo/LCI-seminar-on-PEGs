LATEXFLAGS?=-interaction=nonstopmode -file-line-error
PDFLATEX=pdflatex
BIBTEX=bibtex
 
JOB=seminar
TEXS=$(wildcard *.tex) $(wildcard *.sty) $(wildcard *.cls)
PICS=$(wildcard *.png) $(filter-out $(JOB).pdf,$(wildcard *.pdf)) $(wildcard *.jpg)
BIBS=$(wildcard *.bib) $(wildcard *.bst)
 
.DEFAULT: all
.PHONY: all clean
 
all: $(JOB).pdf
 
$(JOB).aux: | $(TEXS) $(PICS)
	$(PDFLATEX) $(LATEXFLAGS) $(JOB)
 
$(JOB).bbl: $(JOB).aux $(BIBS)
	$(BIBTEX) $(JOB)
 
$(JOB).pdf: $(TEXS) $(PICS) $(JOB).aux $(JOB).bbl
	@cp -p $(JOB).aux $(JOB).aux.bak
	$(PDFLATEX) $(LATEXFLAGS) $(JOB)
	@if cmp -s $(JOB).aux $(JOB).aux.bak; \
	then touch -r $(JOB).aux.bak $(JOB).aux; \
	else NEWS="$$NEWS -W $(JOB).aux"; fi; rm $(JOB).aux.bak; \
	if [ -n "$$NEWS" ]; then $(MAKE) $$NEWS $@; fi
 
clean:
	rm -f $(JOB).aux $(JOB).log $(JOB).blg $(JOB).bbl $(JOB).out $(JOB).pdf