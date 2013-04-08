.PHONY: Build Lexer Parser clean docs

Build: Parser Lexer
	g++ -o compiler lexer.cpp parser.cpp driver.cpp ast.cpp compiler.cpp

Lexer: lexer.l
	flex -o lexer.cpp lexer.l 

Parser: parser.y
	bison -d -o parser.cpp parser.y
clean:
	rm -f lexer.cpp *.hh parser.hpp parser.cpp compiler
docs: parser.y
	bison --xml=parser.xml -o parser.cpp parser.y
	xsltproc /usr/share/bison/xslt/xml2xhtml.xsl parser.xml > parser.html

