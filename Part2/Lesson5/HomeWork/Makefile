.PHONY: build

build:
	g++ -o bsqrt bsqrt.cpp `llvm-config-mp-3.0 --cppflags --ldflags --libs` -ldl
	./bsqrt 2> bsqrt.lasm
	llc-mp-3.0 -disable-cfi -mattr=-avx bsqrt.bc
	gcc bsqrt.s

