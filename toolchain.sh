#!/usr/bin/env sh

set -e
set -x

make tools/install $@
make toolchain/install $@
