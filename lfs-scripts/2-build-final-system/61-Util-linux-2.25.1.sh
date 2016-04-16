#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=util-linux-2.25.1.tar.xz
    srcdir=util-linux-2.25.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # The FHS recommends using the /var/lib/hwclock directory instead of 
    # the usual /etc directory as the location for the adjtime file. 
    # Create a directory to enable storage for the hwclock program:
    mkdir -pv /var/lib/hwclock

    # Fix one of the regression tests:
    sed -e 's/2^64/(2^64/' -e 's/E </E) <=/' -e 's/ne /eq /' \
        -i tests/ts/ipcs/limits2

    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
        --docdir=/usr/share/doc/util-linx-2.25.1
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
