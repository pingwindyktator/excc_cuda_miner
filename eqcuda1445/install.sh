#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "$DIR" > /dev/null                                                  && \
sudo cp libeqcuda1445.so /usr/lib