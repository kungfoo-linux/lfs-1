#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package need yasm to build.

srcfil=xvidcore-1.3.3.tar.gz
srcdir=xvidcore
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/build/generic

# Fix error during make install if reintalling or upgrading.
sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

chmod -v 755 $BUILDDIR/usr/lib/libxvidcore.so.4.3
install -v -m755 -d $BUILDDIR/usr/share/doc/xvidcore-1.3.3/examples
install -v -m644 ../../doc/* $BUILDDIR/usr/share/doc/xvidcore-1.3.3
install -v -m644 ../../examples/* \
	$BUILDDIR/usr/share/doc/xvidcore-1.3.3/examples

cleanup_src ../../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Open source MPEG-4 video codec
 .
 [libxvidcore.so]
 provides functions to encode and decode most MPEG-4 video data.
EOF
}

build
