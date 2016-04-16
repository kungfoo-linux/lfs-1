#!/bin/bash -e
. ../lfs.comm

# The Pkg-config package contains a tool for passing the include path and/or
# library paths to build tools during the configure and make file execution.

build_src() {
    srcfil=pkg-config-0.28.tar.gz
    srcdir=pkg-config-0.28

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --with-internal-glib \
        --disable-host-tool \
        --docdir=/usr/share/doc/pkg-config-0.28
    make -j$JOBS

    # Ensure that all 25 tests in the test suite passed:
    make check 2>&1 | tee pkg-config-check-log
    num=`awk '/tests passed/{total+=$2} ; END{print total}' pkg-config-check-log`
    if [ "$num" != "25" ]; then
        exit 1
    fi

    make install

    cd .. && rm -rf $srcdir
}

build

