#!/bin/bash -e
. ../lfs.comm

# The Expect package contains a program for carrying out scripted dialogues
# with other interactive programs.

build_src() {
    srcfil=expect5.45.tar.gz
    srcdir=expect5.45

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    cp -v configure{,.orig}
    sed 's:/usr/local/bin:/bin:' configure.orig > configure

    ./configure --prefix=/tools \
        --with-tcl=/tools/lib \
        --with-tclinclude=/tools/include \
        --with-x=no
    make -j$JOBS
    make SCRIPTS="" install

    cd ..
}

build
