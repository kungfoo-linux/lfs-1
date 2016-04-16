#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=bash-4.3.tar.gz
    srcdir=bash-4.3

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    patch -Np1 -i $PATCHES/bash-4.3-upstream_fixes-7.patch

    ./configure --prefix=/usr \
        --bindir=/bin \
        --docdir=/usr/share/doc/bash-4.3 \
        --without-bash-malloc \
        --with-installed-readline
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
