#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=binutils-2.24.tar.bz2
    srcdir=binutils-2.24

    # Verify that the PTYs are working properly inside the chroot environment
    # by performing a simple test. If OK, The correct output will be:
    # "spawn ls":
    str=`expect -c "spawn ls"`
    if [ "${str:0:8}" != "spawn ls" ]; then
        echo "spawn ls not expect."
        exit 1
    fi

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Suppress the installation of and outdated standares.info file as a newer
    # one is installed later on in the Autoconf instructions:
    rm -fv etc/standards.info
    sed -i.bak '/^INFO/s/standards.info //' etc/Makefile.in

    # Add an upstream patch to use GCC's link time optimization (LTO) by
    # default:
    patch -Np1 -i $PATCHES/binutils-2.24-load_gcc_lto_plugin_by_default-1.patch

    # Fix some LTO tests in the test suite:
    patch -Np1 -i $PATCHES/binutils-2.24-lto_testsuite-1.patch

    mkdir -pv ../binutils-build && cd ../binutils-build
    ../$srcdir/configure \
        --prefix=/usr \
        --enable-shared \
        --disable-werror
    make tooldir=/usr -j$JOBS

    # The test suite for Binutils in this section is considered cirtical. 
    # Do not skip it under any circumstances:
    set +e; make -k check; set -e

    make tooldir=/usr install

    cd .. && rm -rf $srcdir binutils-build
}

build
