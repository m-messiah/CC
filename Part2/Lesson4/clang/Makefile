.PHONY: byte-code interpret assembler code-generator native compile run

help:
	@echo "tagets: byte-code interpret assembler code-generator native compile run help"

compile:
	clang main.c -o main

byte-code:
	clang -O0 -emit-llvm main.c -c -o main.bc

assembler:
	llvm-dis-3.0 < main.bc | less

code-generator:
	llc-3.0 -disable-cfi main.bc -o main.s

native:
	gcc main.s -o main.native

run:
	./main

interpret:
	lli-3.0 main.bc
