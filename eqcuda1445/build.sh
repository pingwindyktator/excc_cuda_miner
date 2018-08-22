#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
NVCC_FLAGS="-arch sm_35 -O3 -Xptxas -O3 -Xcompiler -O3"
CXX_FLAGS="-O3 -march=x86-64 -mtune=generic -std=c++17"
cd "$DIR" > /dev/null                                                                   && \

g++ $CXX_FLAGS -fPIC -c blake/blake2b.cpp -o blake.o                                    && \
nvcc $NVCC_FLAGS -rdc=true --compiler-options '-fPIC' -c -o solver.o  solver.cu         && \
nvcc $NVCC_FLAGS -dlink --compiler-options '-fPIC' -o  eqcuda1445.o solver.o            && \
g++ $CXX_FLAGS -fPIC -Wl,-soname,libeqcuda1445.so -shared -o libeqcuda1445.so eqcuda1445.o solver.o blake.o -L/usr/local/cuda/lib64 -lcudart_static  -ldl -lrt -lpthread

