#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=yelp-xsl-3.12.0.tar.xz
srcdir=yelp-xsl-3.12.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libxslt (>= 1.1.28), Itstool (>= 2.0.2)
Description: XSL stylesheets for the yelp help browser
EOF
}

build
