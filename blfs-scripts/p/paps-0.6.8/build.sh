#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=paps-0.6.8.tar.gz
srcdir=paps-0.6.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/paps-0.6.8-freetype_fix-1.patch

./configure --prefix=/usr \
	--mandir=/usr/share/man
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/paps-0.6.8
install -v -m644 doxygen-doc/html/* $BUILDDIR/usr/share/doc/paps-0.6.8

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Pango (>= 1.36.7)
Description: Plain Text to PostScript converter
 paps is a text to PostScript converter that works through Pango. Its input is
 a UTF-8 encoded text file and it outputs vectorized PostScript. It may be
 used for printing any complex script supported by Pango.
EOF
}

build
