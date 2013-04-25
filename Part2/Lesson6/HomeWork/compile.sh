#!/bin/bash

./compiler $1
llc-3.2 -disable-cfi -mattr=-avx $1.bc
clang $1.s print.c -o $1.elf
