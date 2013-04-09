.PHONY: byte-code interpret assembler code-generator native compile run

help:
	@echo "tagets: byte-code interpret assembler code-generator native compile run help"

compile:
	clang hello.c -o hello

byte-code:
	clang -O0 -emit-llvm hello.c -c -o hello.bc

assembler:
	llvm-dis-mp-3.0 < hello.bc | less

code-generator:
	llc-mp-3.0 -disable-cfi hello.bc -o hello.s

native:
	gcc hello.s -o hello.native

run:
	./hello

interpret:
	lli-mp-3.0 hello.bc
