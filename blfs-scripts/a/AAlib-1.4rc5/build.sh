#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=aalib-1.4rc5.tar.gz
srcdir=aalib-1.4.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i -e '/AM_PATH_AALIB,/s/AM_PATH_AALIB/[&]/' aalib.m4

./configure --prefix=/usr \
	--infodir=/usr/share/info \
	--mandir=/usr/share/man \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-app (>= 7.7), slang (>= 2.2.4)
Description: ASCII art library
 AAlib is a portable ASCII art graphics library. Internally, it works like a
 graphics display, but the output is rendered into gorgeous platform
 independent ASCII graphics.
 .
 [aafire]
 is little toy of AAlib, rendering an animated fire in ASCII Art.
 .
 [aainfo]
 provides information for your current settings related to AAlib.
 .
 [aalib-config]
 provides configuration info for AAlib.
 .
 [aatest]
 shows the abilities of AAlib in a little test.
 .
 [libaa.{so,a}]
 is a collection of routines to render any graphical input in portable format
 to ASCII Art. It can be used through many programs and has a very well
 documented API, so you can easily put it into your own programs.
EOF
}

build
