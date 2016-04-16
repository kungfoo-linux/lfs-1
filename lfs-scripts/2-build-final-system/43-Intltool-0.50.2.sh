#!/bin/bash -e
. ../lfs.comm

# The Intltool is an internationalization tool used for extracting
# translatable strings from source files.

build_src() {
    srcfil=intltool-0.50.2.tar.gz
    srcdir=intltool-0.50.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.50.2/I18N-HOWTO

    cd .. && rm -rf $srcdir
}

build
