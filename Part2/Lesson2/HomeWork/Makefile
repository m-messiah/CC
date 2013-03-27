.PHONY: build docs run clean


NAME=lisp_calc

build: ${NAME}.y ${NAME}.l Makefile
	bison -o ${NAME}_parser.c ${NAME}.y
	flex -o ${NAME}_lexer.c ${NAME}.l
	g++ -o ${NAME} ${NAME}_parser.c ${NAME}_lexer.c	

docs: ${NAME}.y
	bison --xml=${NAME}.xml -o ${NAME}_parser.c ${NAME}.y
	xsltproc /usr/share/bison/xslt/xml2xhtml.xsl ${NAME}.xml > ${NAME}.html

run: ${NAME}
	./${NAME}

clean:
	rm -f *.c *.h ${NAME}
