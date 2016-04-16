#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fontconfig-2.11.1.tar.bz2
srcdir=fontconfig-2.11.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--disable-docs \
	--docdir=/usr/share/doc/fontconfig-2.11.1
make
make DESTDIR=$BUILDDIR install

install -v -dm755 \
	$BUILDDIR/usr/share/{man/man{1,3,5},doc/fontconfig-2.11.1/fontconfig-devel}
install -v -m644 fc-*/*.1          $BUILDDIR/usr/share/man/man1
install -v -m644 doc/*.3           $BUILDDIR/usr/share/man/man3
install -v -m644 doc/fonts-conf.5  $BUILDDIR/usr/share/man/man5
install -v -m644 doc/fontconfig-devel/* \
	$BUILDDIR/usr/share/doc/fontconfig-2.11.1/fontconfig-devel
install -v -m644 doc/*.{pdf,sgml,txt,html} \
	$BUILDDIR/usr/share/doc/fontconfig-2.11.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: FreeType (>= 2.5.3)
Description: font configuration and customization library
 .
 [fc-cache]
 is used to create font information caches.
 .
 [fc-cat]
 is used to read font information caches.
 .
 [fc-list]
 is used to create font lists.
 .
 [fc-match]
 is used to match available fonts, or find fonts that match a given pattern.
 .
 [fc-pattern]
 is used to parse pattern (empty pattern by default) and show the parsed
 result.
 .
 [fc-query]
 is used to query fonts files and print resulting patterns.
 .
 [fc-scan]
 is used to scan font files and directories, and print resulting patterns.
 .
 [fc-validate]
 is used to validate font files.
 .
 [libfontconfig.so]
 contains functions used by the Fontconfig programs and also by other programs
 to configure or customize font access. 
EOF
}

build
