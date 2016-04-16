#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=xz-5.0.5.tar.xz
    srcdir=xz-5.0.5

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/xz-5.0.5
    make -j$JOBS
    make install

    mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
    mv -v   /usr/lib/liblzma.so.* /lib
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

    cd .. && rm -rf $srcdir
}

build
