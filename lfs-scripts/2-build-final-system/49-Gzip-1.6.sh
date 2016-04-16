#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=gzip-1.6.tar.xz
    srcdir=gzip-1.6

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr --bindir=/bin
    make -j$JOBS
    make install

    mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
    mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin

    cd .. && rm -rf $srcdir
}

build
