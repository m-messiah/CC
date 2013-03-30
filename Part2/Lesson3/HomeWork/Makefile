.PHONY: Build Lexer Parser clean

Build: Parser Lexer
	g++ -o compiler lexer.cpp parser.cpp driver.cpp ast.cpp compiler.cpp

Lexer: lexer.l
	flex -o lexer.cpp lexer.l 

Parser: parser.y
	bison -d -o parser.cpp parser.y
clean:
	rm -f lexer.cpp *.hh parser.hpp parser.cpp compiler
