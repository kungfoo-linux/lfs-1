#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=totem-pl-parser-3.10.2.tar.xz
srcdir=totem-pl-parser-3.10.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GMime (>= 2.6.20), libsoup (>= 2.46.0), \
gobject-introspection (>= 1.40.0), libarchive (>= 3.1.2), libgcrypt (>= 1.6.2)
Description: Playlist parser library from the Totem Movie Player
EOF
}

build
