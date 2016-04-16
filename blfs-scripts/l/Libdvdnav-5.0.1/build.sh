#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libdvdnav-5.0.1.tar.bz2
srcdir=libdvdnav-5.0.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--docdir=/usr/share/doc/libdvdnav-5.0.1
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libdvdread (>= 5.0.0)
Description: A library for reading DVD video discs based on Ogle code
 libdvdnav is a library that allows easy use of sophisticated DVD navigation
 features such as DVD menus, multiangle playback and even interactive DVD
 games.
EOF
}

build
