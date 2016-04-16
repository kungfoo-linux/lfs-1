#!/bin/bash -e
. ../lfs.comm

# The GMP package contains math libraries. These have useful functions for
# arbitrary precision arithmetic.

build_src() {
    srcfil=gmp-6.0.0a.tar.xz
    srcdir=gmp-6.0.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # If you are building for 32-bit x86, but you have a CPU which is capable
    # of running 64-bit code and you have specified CFLAGS in the environment,
    # the configure script will attempt to configure for 64-bits and fail.
    # Avoid this by invoking the configure command below with:
    #   ABI=32 ./configure ...

    ./configure --prefix=/usr \
        --enable-cxx \
        --docdir=/usr/share/doc/gmp-6.0.0a
    make -j$JOBS
    make html

    # The test suite for GMP in this section is considered critical. 
    # Do not skip it under any circumstances:
    make check 2>&1 | tee gmp-check-log

    # Ensure that all 188 tests in the test suite passed:
    num=`awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log`
    if [ "$num" != "188" ]; then
        exit 1
    fi

    make install
    make install-html

    cd .. && rm -rf $srcdir
}

build
