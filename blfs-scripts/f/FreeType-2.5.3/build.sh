#!/bin/bash -e
. ../../blfs.comm

build_src() {
# NOTE: First, install without Harfbuzz-0.9.35, after it is installed,
# reinstall FreeType-2.5.3.

srcfil=freetype-2.5.3.tar.bz2
srcdir=freetype-2.5.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/freetype-doc-2.5.3.tar.bz2 \
	--strip-components=2 -C docs

sed -i  -e "/AUX.*.gxvalid/s@^# @@" \
	-e "/AUX.*.otvalid/s@^# @@" \
	modules.cfg

sed -ri -e 's:.*(#.*SUBPIXEL.*) .*:\1:' \
	include/config/ftoption.h

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/freetype-2.5.3
cp -v -R docs/*     $BUILDDIR/usr/share/doc/freetype-2.5.3

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Which (>= 2.20), Harfbuzz (>= 0.9.35), libpng (>= 1.6.13)
Description: a free and portable font rendering engine
 The FreeType2 package contains a library which allows applications to
 properly render TrueType fonts.
 .
 [freetype-config]
 is used to get FreeType compilation and linking information.
 .
 [libfreetype.so]
 contains functions for rendering various font types, such as TrueType and
 Type1. 
EOF
}

build
