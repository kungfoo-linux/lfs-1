#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pango-1.36.7.tar.xz
srcdir=pango-1.36.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc
make
make DESTDIR=$BUILDDIR install

make install
pango-querymodules --update-cache
cp /usr/lib/pango/1.8.0/modules.cache $BUILDDIR/usr/lib/pango/1.8.0/

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Cairo (>= 1.12.16), Harfbuzz (>= 0.9.35), Xorg-lib (>= 7.7), \
gobject-introspection (>= 1.40.0)
Description: Layout and rendering of internationalized text
 Pango is a library for layout and rendering of text, with an emphasis on
 internationalization. Pango can be used anywhere that text layout is needed.
 however, most of the work on Pango-1.0 was done using the GTK+ widget toolkit
 as a test platform. Pango forms the core of text and font handling for
 GTK+-2.0.
 .
 Pango is designed to be modular; the core Pango layout can be used with four
 different font backends:
  - Core X windowing system fonts
  - Client-side fonts on X using the Xft library
  - Direct rendering of scalable fonts using the FreeType library
  - Native fonts on Microsoft backends
 .
 [pango-querymodules]
 is a module registration utility that collects information about Pango
 loadable modules.
 .
 [pango-view]
 renders a given file through Pango for viewing purposes.
 .
 [libpango-1.0.so]
 contain low level layout rendering routines, a high level driver for laying
 out entire blocks of text, and routines to assist in editing
 internationalized text.
EOF
}

build
