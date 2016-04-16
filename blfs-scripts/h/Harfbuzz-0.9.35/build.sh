#!/bin/bash -e
. ../../blfs.comm

build_src() {
# NOTE: after Harfbuzz-0.9.35 is installed, reinstall FreeType-2.5.3.

srcfil=harfbuzz-0.9.35.tar.bz2
srcdir=harfbuzz-0.9.35
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-gobject
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), ICU (>= 53.1), FreeType (>= 2.5.3)
Description: OpenType text shaping engine
 .
 [libharfbuzz.so]
 contains functions for complex text shaping. 
EOF
}

build
