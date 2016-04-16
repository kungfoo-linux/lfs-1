#!/bin/bash -e
. ../lfs.comm

# The Util-linux package contains miscellaneous utillty programs.

build_src() {
    srcfil=util-linux-2.25.1.tar.xz
    srcdir=util-linux-2.25.1

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools \
        --without-python \
        --disable-makeinstall-chown \
        --without-systemdsystemunitdir \
        PKG_CONFIG=""
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
