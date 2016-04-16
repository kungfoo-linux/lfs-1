#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgsf-1.14.30.tar.xz
srcdir=libgsf-1.14.30
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
Depends: GLib (>= 2.40.0), libxml2 (>= 2.9.1), gdk-pixbuf (>= 2.30.8), \
gobject-introspection (>= 1.40.0)
Description: GNOME Structured File library
 The libgsf package contains the library used for providing an extensible
 input/output abstraction layer for structured file formats.
 .
 [gsf]
 is a simple archive utility, somewhat similar to tar(1).
 .
 [gsf-office-thumbnailer]
 is used internally by GNOME applications such as Nautilus to generate
 thumbnails of several types of office application files.
 .
 [gsf-vba-dump]
 is used to extract Visual Basic for Applications macros from files.
 .
 [libgsf-1.so]
 contains the libgsf API functions.
EOF
}

build
