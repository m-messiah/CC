.PHONY: build clean

build:
	g++ -o gcd gcd.cpp `llvm-config-3.2 --cppflags --ldflags --libs` -ldl
	./gcd 2> gcd.lasm
	llc-3.2 -disable-cfi -mattr=-avx gcd.bc -o gcd.s
	gcc gcd.s -o gcd.native

clean:
	ls | grep gcd | grep -v cpp | xargs rm
