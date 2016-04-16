#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xkeyboard-config-2.12.tar.bz2
srcdir=xkeyboard-config-2.12
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure $XORG_CONFIG \
	--with-xkb-rules-symlink=xorg
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7)
Description: the keyboard configuration database for X
EOF
}

build
