#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tidy-cvs_20101110.tar.bz2
srcdir=tidy-cvs_20101110
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

install -v -m644 -D htmldoc/tidy.1 $BUILDDIR/usr/share/man/man1/tidy.1
install -v -m755 -d $BUILDDIR/usr/share/doc/tidy-cvs_20101110
install -v -m644 htmldoc/*.{html,gif,css} \
	$BUILDDIR/usr/share/doc/tidy-cvs_20101110

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: HTML syntax checker and reformatter
 The HTML Tidy package contains a command line tool and libraries used to read
 HTML, XHTML and XML files and write cleaned up markup. It detects and
 corrects many common coding errors and strives to produce visually equivalent
 markup that is both W3C compliant and compatible with most browsers.
 .
 [tab2space]
 is a utility to expand tabs and ensure consistent line endings.
 .
 [tidy]
 validates, corrects, and pretty-prints HTML files.
 .
 [libtidy.so]
 library provides the HTML Tidy API functions to tidy and can also be called
 by other programs.
EOF
}

build
