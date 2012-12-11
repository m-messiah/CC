.PHONY: build run clean

# calcLexer.java calcParser.java calcTree.java calc.java

NAME=calc
CP=/usr/share/java/antlr3-runtime.jar:/usr/share/java/antlr3.jar:/usr/share/java/stringtemplate.jar:.

build: ${NAME}.g ${NAME}Tree.g Makefile
	antlr3 -o output ${NAME}.g ${NAME}Tree.g
	javac -cp ${CP}  ${NAME}.java output/${NAME}Lexer.java output/${NAME}Parser.java output/${NAME}Tree.java

run:
	java -cp ${CP}:.:output ${NAME}

clean:
	rm -rf *.class output
