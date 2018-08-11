#!/bin/bash

OWRT="$(realpath $(dirname ${BASH_SOURCE}))"
echo "* OpenWRT...: ${OWRT}"

ARCH="$(cat ${OWRT}/.config | sed -n 's/^CONFIG_ARCH="\(.*\)"$/\1/p')"
echo "* ARCH......: ${ARCH}"
export HOST="${ARCH}-openwrt-linux"

CPU_TYPE="$(cat ${OWRT}/.config | sed -n 's/^CONFIG_CPU_TYPE="\(.*\)"$/\1/p')"
echo "* CPU TYPE..: ${CPU_TYPE}"

TARGET_BOARD="$(cat ${OWRT}/.config | sed -n 's/^CONFIG_TARGET_BOARD="\(.*\)"$/\1/p')"
echo "* TARGET....: ${TARGET_BOARD}"

TOOLCHAIN_DIR="$(realpath ${OWRT}/staging_dir/toolchain-${ARCH}_${CPU_TYPE}*)"
echo "* Toolchain.: ${TOOLCHAIN_DIR}"

export PATH="${TOOLCHAIN_DIR}/bin:${PATH}"
export STAGING_DIR="${OWRT}/staging_dir"
TARGET_DIR="$(realpath ${STAGING_DIR}/target-${ARCH}_${CPU_TYPE}*)"
echo "* Target dir: ${TARGET_DIR}"
export CC="${HOST}-gcc"
export CXX="${HOST}-g++"
export CFLAGS="-I${TARGET_DIR}/usr/include"
export CXXFLAGS="${CFLAGS}"
TARGET_DIR_ROOT="$(realpath ${TARGET_DIR}/root-${TARGET_BOARD})"
echo "* Target dir: ${TARGET_DIR_ROOT}"
export LDFLAGS="-L${TARGET_DIR}/usr/lib -L${TARGET_DIR_ROOT}/usr/lib"
export PKG_CONFIG_PATH="${TARGET_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="${TARGET_DIR}/usr/lib/pkgconfig"

check_dirs[0]="${TOOLCHAIN_DIR}"
check_dirs[1]="${TARGET_DIR}"
check_dirs[2]="${TARGET_DIR_ROOT}"
for dir in ${check_dirs[*]}; do
    test -d "${dir}" || echo "* NOT EXIST: ${dir}" >&2
done
