#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CXX_FLAGS="-O3 -march=x86-64 -mtune=generic -std=c++17"
cd "$DIR" > /dev/null                                     && \

bash eqcuda1445/build.sh                                  && \
g++ $CXX_FLAGS main.cpp -o main  -L"$DIR/eqcuda1445" -leqcuda1445
