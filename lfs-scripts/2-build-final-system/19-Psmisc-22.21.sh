#!/bin/bash -e
. ../lfs.comm

# The Psmisc package contains programs for displaying information about
# running processes.

build_src() {
    srcfil=psmisc-22.21.tar.gz
    srcdir=psmisc-22.21

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make install

    mv -v /usr/bin/fuser   /bin
    mv -v /usr/bin/killall /bin

    cd .. && rm -rf $srcdir
}

build
