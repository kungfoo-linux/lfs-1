#!/bin/bash -e
. ../lfs.comm

# The IPRoute2 package contains programs for basic and advanced IPV4-based
# networking.

build_src() {
    srcfil=iproute2-3.16.0.tar.xz
    srcdir=iproute2-3.16.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # The arpd binary included in this package is dependent on 
    # Berkeley DB. Because arpd is not a very common requirement on a 
    # base Linux system, remove the dependency on Berkeley DB by applying 
    # the sed commands below. If the arpd binary is needed, instructions 
    # for compiling Berkeley DB can be found in the BLFS Book.
    sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
    sed -i /ARPD/d Makefile
    sed -i 's/arpd.8//' man/man8/Makefile

    make -j$JOBS
    make DOCDIR=/usr/share/doc/iproute2-3.16.0 install

    cd .. && rm -rf $srcdir
}

build
