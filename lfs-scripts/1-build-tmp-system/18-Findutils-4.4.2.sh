#!/bin/bash -e
. ../lfs.comm

# The Findutils package contains programs to find files. These programs are
# provided to recursively search through a directory tree and to create,
# maintain, and search a database (often faster than the recursive find, but 
# unreliable if the database has not been recently updated). 

build_src() {
    srcfil=findutils-4.4.2.tar.gz
    srcdir=findutils-4.4.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
