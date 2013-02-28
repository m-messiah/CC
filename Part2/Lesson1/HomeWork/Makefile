.PHONY: build run clean


NAME=calc
PROGRAM=program

build: ${NAME}.y Makefile
	bison -d ${NAME}.y
	flex -o ${NAME}.toc.c ${NAME}.l
	g++ -o ${NAME} ${NAME}.toc.c ${NAME}.tab.c	

run: ${NAME}
	./${NAME}

clean:
	rm -f *.c *.h ${NAME}
