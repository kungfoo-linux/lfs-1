#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=imlib2-1.4.6.tar.bz2
srcdir=imlib2-1.4.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -e '/DGifOpen/s:fd:&, NULL:' \
	-e '/DGifCloseFile/s:gif:&, NULL:' \
	-i src/modules/loaders/loader_gif.c
sed -i 's/@my_libs@//' imlib2-config.in

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/imlib2-1.4.6
install -v -m644 doc/{*.gif,index.html} \
	$BUILDDIR/usr/share/doc/imlib2-1.4.6

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7), libpng (>= 1.6.13), libjpeg-turbo (>= 1.3.1), \
LibTIFF (>= 4.0.3), giflib (>= 5.1.0)
Description: image loading, rendering, saving library
 Imlib2 is a library that does image file loading and saving as well as
 rendering, manipulation, arbitrary polygon support, etc.
 .
 [libImlib2.so]
 provides the functions for programs to deal with various image data formats.
EOF
}

build
