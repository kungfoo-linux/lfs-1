#!/bin/bash -e
. ../lfs.comm

# The Tcl package contains the Tool Command Language.
# This package and the next three (Expect, DejaGNU, and Check) are installed
# to support running the test for GCC and Binutils and other packages.
# Installing four packages for testing purposes may seem excessive, but it is
# very reassuring, if not essential, to know that the most important tools
# are working properly.

build_src() {
    srcfil=tcl8.6.2-src.tar.gz
    srcdir=tcl8.6.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir/unix

    ./configure --prefix=/tools
    make -j$JOBS
    make install

    chmod -v u+w /tools/lib/libtcl8.6.so
    make install-private-headers
    ln -sv tclsh8.6 /tools/bin/tclsh

    cd ../..
}

build
