.PHONY: build run clean

build: calc3.g Makefile
	antlr3 calc3.g
	javac -cp /usr/share/java/antlr3-runtime.jar:/usr/share/java/antlr3.jar:. calcLexer.java calcParser.java calc.java

run:
	java -cp /usr/share/java/antlr3-runtime.jar:/usr/share/java/antlr3.jar:. calc

clean:
	rm -f *.class calcLexer.java calcParser.java calc.tokens *__*
