#!/bin/bash -e
. ../lfs.comm

# The Sysvinit package contains programs for controlling the startup,
# running, and shutdown of the system.

build_src() {
    srcfil=sysvinit-2.88dsf.tar.bz2
    srcdir=sysvinit-2.88dsf

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Apply a patch that removes several programs installed by other 
    # packages, clarifies a message, and fixes a compiler warning:
    patch -Np1 -i $PATCHES/sysvinit-2.88dsf-consolidated-1.patch

    make -C src
    make -C src install

    cd .. && rm -rf $srcdir
}

build
