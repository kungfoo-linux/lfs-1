#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=babl-0.1.10.tar.bz2
srcdir=babl-0.1.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/gtk-doc/html/babl/graphics
install -v -m644 docs/*.{css,html} $BUILDDIR/usr/share/gtk-doc/html/babl
install -v -m644 docs/graphics/*.{html,png,svg} \
	$BUILDDIR/usr/share/gtk-doc/html/babl/graphics

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gobject-introspection (>= 1.40.0), Vala (>= 0.24.0)
Description: a dynamic, any to any, pixel format conversion library
 .
 [libbabl.so]
 contains functions to access BablFishes to convert between formats.
EOF
}

build
