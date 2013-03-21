.PHONY: calc calc.html clean

NAME=calc

calc: ${NAME}.y ${NAME}.l
	bison -o ${NAME}_parser.cpp ${NAME}.y
	flex -o ${NAME}_lexer.cpp ${NAME}.l 
	g++ ${NAME}_parser.cpp ${NAME}_lexer.cpp -o ${NAME}

calc.html: ${NAME}.y
	bison --xml=${NAME}.xml -o ${NAME}_parser.cpp ${NAME}.y
	xsltproc /usr/share/bison/xslt/xml2xhtml.xsl ${NAME}.xml > ${NAME}.html

clean:
	rm -f ${NAME}*.cpp ${NAME}*.h ${NAME} ${NAME}*.*ml 
