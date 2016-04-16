#!/bin/bash -e
. ../lfs.comm

# The Procps package contains programs for monitoring processes.

build_src() {
    srcfil=procps-ng-3.3.9.tar.xz
    srcdir=procps-ng-3.3.9

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --exec-prefix= \
        --libdir=/usr/lib \
        --docdir=/usr/share/doc/procps-ng-3.3.9 \
        --disable-static \
        --disable-kill
    make -j$JOBS
    make install

    mv -v /usr/bin/pidof /bin
    mv -v /usr/lib/libprocps.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) \
        /usr/lib/libprocps.so

    cd .. && rm -rf $srcdir
}

build
