#!/bin/bash -e
. ../../blfs.comm

# dpkg - Debian's package maintenance system.
# The primary interface for the dpkg suite is the 'dselect' program;
# a more low-level and less user-friendly interface is available in the
# form of the ‘dpkg’ command.

build_src() {
srcfil=dpkg_1.16.15.tar.xz
srcdir=dpkg-1.16.15
BUILDDIR=$PWD/$srcdir-$ARCHITECTURE

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var
make
make DESTDIR=$BUILDDIR install
touch $BUILDDIR/var/lib/dpkg/{status,available}

cleanup_src .. $srcdir
}

build_src
