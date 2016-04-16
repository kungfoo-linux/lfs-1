#!/bin/bash -e
. ../lfs.comm

# The attr package contains utilities to administer the extended attributes
# on filesystme objects.

build_src() {
    srcfil=attr-2.4.47.src.tar.gz
    srcdir=attr-2.4.47

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in

    ./configure --prefix=/usr --bindir=/bin
    make -j$JOBS

    # The tests need to be run on a filesystem that supports extended
    # attributes such as the ext2, ext3, or ext4 filesystems.
    make -j1 tests root-tests

    make install install-dev install-lib
    chmod -v 755 /usr/lib/libattr.so

    mv -v /usr/lib/libattr.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

    cd .. && rm -rf $srcdir
}

build
