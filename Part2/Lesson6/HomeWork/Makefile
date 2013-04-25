.PHONY: Build Lexer Parser

Build: Parser Lexer
	clang++ -o compiler lexer.cpp parser.cpp driver.cpp compiler.cpp ast_codegen.cpp ast_tostring.cpp ast.cpp `llvm-config-3.2 --cppflags --ldflags --libs` 

Lexer: lexer.l
	flex -o lexer.cpp lexer.l 

Parser: parser.y
	bison -d -o parser.cpp parser.y
