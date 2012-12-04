.PHONY: build run clean

#CP=/usr/share/antlr-3/lib/antlr3.jar:/usr/share/stringtemplate/lib/stringtemplate.jar:/usr/share/antlr/lib/antlr.jar


# calcLexer.java calcParser.java calcTree.java calc.java

NAME=calc
CP=/usr/share/java/antlr3-runtime.jar:/usr/share/java/antlr3.jar:/usr/share/java/stringtemplate.jar:.

build: ${NAME}.g Makefile
	antlr3 -o output ${NAME}.g 
	javac -cp ${CP}  Main.java output/${NAME}Lexer.java output/${NAME}Parser.java 

run:
	java -cp ${CP}:.:output Main

clean:
	rm -rf *.class output
