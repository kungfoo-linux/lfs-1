#!/bin/bash -e
. ../lfs.comm

# The MPC package contains a library for the arithmetic of complex numbers
# with arbitrary high precision and correct rounding of the result.

build_src() {
    srcfil=mpc-1.0.2.tar.gz
    srcdir=mpc-1.0.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/mpc-1.0.2
    make -j$JOBS
    make html

    # Ensure that all 64 tests in the test suite passed. 
    # Check the results by issuing the following command:
    make check 2>&1 | tee mpc-check-log
    num=`awk '/tests passed/{total+=$2} ; END{print total}' mpc-check-log`
    if [ "$num" != "64" ]; then
        exit 1
    fi

    make install
    make install-html

    cd .. && rm -rf $srcdir
}

build
