.PHONY: build clean

NAME=calc

build: ${NAME}.y ${NAME}.l Makefile
	bison -o ${NAME}_parser.cpp ${NAME}.y
	flex -o ${NAME}_lexer.cpp ${NAME}.l
	g++ ${NAME}_parser.cpp ${NAME}_lexer.cpp -o ${NAME}

clean:
	rm -f ${NAME}*.cpp ${NAME}*.h ${NAME}
