NAME = intro-to-git
TEX  = ${NAME}.tex
TOC  = ${NAME}.toc
DVI  = ${NAME}.dvi
PS   = ${NAME}.ps
PDF  = ${NAME}.pdf

SVG=$(wildcard *.svg)
EPS=$(SVG:.svg=.eps)

#LATEX = latex -interaction errorstopmode
LATEX = latex -interaction nonstopmode

.PHONY: run eps ps pdf clean distclean pdf-lmk
default: pdf-lmk

pdf-lmk: ${EPS}
	latexmk -pdf ${NAME}

eps: ${EPS}

ps: ${DVI}
${DVI}: ${TEX} ${EPS}
	-rm -f .${TOC}.sum
	md5sum ${TOC} > .${TOC}.sum || touch .${TOC}.sum
	${LATEX} $< || ( rc=$$? ; rm -f ${TOC} ${DVI} ; echo ==== $$rc ==== ; exit $$rc )
	md5sum -c .${TOC}.sum || ${LATEX} $<

ps: ${PS}
${PS}: ${DVI}
	dvips $<

pdf: ${PDF}
${PDF}: ${PS}
	ps2pdf $<

${EPS}: %.eps: %.svg
	inkscape -D --export-type=eps $@ $<

distclean: clean
	-rm -f ${EPS}

clean:
	-rm -f *~ *.log
	-rm -f ${DVI} ${TOC} ${PS} ${PDF}
	-rm -f $(foreach x,log vrb nav out snm toc dvi aux,${NAME}.${x})
