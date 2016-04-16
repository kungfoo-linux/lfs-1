#!/bin/bash -e
. ../lfs.comm

# The MPFR package contains functions for multiple precision math.

build_src() {
    srcfil=mpfr-3.1.2.tar.xz
    srcdir=mpfr-3.1.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    patch -Np1 -i $PATCHES/mpfr-3.1.2-upstream_fixes-2.patch

    ./configure --prefix=/usr \
        --enable-thread-safe \
        --docdir=/usr/share/doc/mpfr-3.1.2
    make -j$JOBS
    make html

    # The test suite for MPFR in this section is considered critical. 
    # Do not skip it under any circumstances:
    make check 2>&1 | tee mpfr-check-log

    # Ensure that all 160 tests in the test suite passed. 
    # Check the results by issuing the following command:
    num=`awk '/tests passed/{total+=$2} ; END{print total}' mpfr-check-log`
    if [ "$num" != "160" ]; then
        exit 1
    fi

    make install
    make install-html

    cd .. && rm -rf $srcdir
}

build
