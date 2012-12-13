.PHONY: build run clean


NAME=compiler
PROGRAM=program
JASM=/usr/lib/jasmin.jar
CP=/usr/share/java/antlr3-runtime.jar:/usr/share/java/antlr3.jar:/usr/share/java/stringtemplate.jar:.

build: ${NAME}.g ${NAME}Tree.g ${NAME}.java Makefile
	antlr3 -o output ${NAME}.g ${NAME}Tree.g
	javac -cp ${CP}  ${NAME}.java output/${NAME}Lexer.java output/${NAME}Parser.java output/${NAME}Tree.java

run: ${NAME}.class
	java -cp ${CP}:.:output ${NAME}

compile: 
	java -cp ${CP}:.:output ${NAME} > output/${NAME}.j
	java -jar ${JASM} -d output output/${NAME}.j

start: output/${PROGRAM}.class
	java -cp output ${PROGRAM}
	
clean:
	rm -rf *.class output
