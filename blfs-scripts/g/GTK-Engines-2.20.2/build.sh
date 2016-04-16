#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gtk-engines-2.20.2.tar.bz2
srcdir=gtk-engines-2.20.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-lua
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GTK+2 (>= 2.24.24), Lua (>= 5.2.3)
Description: Default GTK2 theme engine
EOF
}

build
