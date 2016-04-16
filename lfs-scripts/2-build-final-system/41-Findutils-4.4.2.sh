#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=findutils-4.4.2.tar.gz
    srcdir=findutils-4.4.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --localstatedir=/var/lib/locate
    make -j$JOBS
    make check
    make install

    # Some of the scripts in the LFS-Bootscripts package depend on find.
    # As /usr may not be available during the early stages of booting,
    # this program needs to be on the root partition. The updatedb script
    # also needs to be modified to correct an explicit path:
    mv -v /usr/bin/find /bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

    cd .. && rm -rf $srcdir
}

build
