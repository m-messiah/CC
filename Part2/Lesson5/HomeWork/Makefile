.PHONY: build clean

build:
	clang++ -o bsqrt bsqrt.cpp print.c `llvm-config-3.2 --cppflags --ldflags --libs` -ldl -g 
	./bsqrt 2> bsqrt.lasm
	llc-3.2 -disable-cfi -mattr=-avx bsqrt.bc -o bsqrt.s
	gcc bsqrt.s print.c -o bsqrt.native

clean:
	ls | grep bsqrt | grep -v cpp | xargs rm
