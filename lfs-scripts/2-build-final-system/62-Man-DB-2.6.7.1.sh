#!/bin/bash -e
. ../lfs.comm

# The Man-DB package contains programs for finding and viewing man pages.

build_src() {
    srcfil=man-db-2.6.7.1.tar.xz
    srcdir=man-db-2.6.7.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/man-db-2.6.7.1 \
        --sysconfdir=/etc \
        --disable-setuid \
        --with-browser=/usr/bin/lynx \
        --with-vgrind=/usr/bin/vgrind \
        --with-grap=/usr/bin/grap
    make -j$JOBS
    make check
    make install

    cd .. && rm -rf $srcdir
}

build
