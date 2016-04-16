#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=poppler-0.26.4.tar.xz
srcdir=poppler-0.26.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--enable-xpdf-headers \
	--enable-libcurl
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/poppler-0.26.4
install -v -m644 README* $BUILDDIR/usr/share/doc/poppler-0.26.4

cleanup_src .. $srcdir

# The additional package consists of encoding files for use with Poppler. The
# encoding files are optional and Poppler will automatically read them if they
# are present. When installed, they enable Poppler to render CJK and Cyrillic
# properly:
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/poppler-data-0.4.7.tar.gz
pushd poppler-data-0.4.7
make DESTDIR=$BUILDDIR prefix=/usr install
popd
rm -rf poppler-data-0.4.7
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Fontconfig (>= 2.11.1), Cairo (>= 1.12.16), \
libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), cURL (>= 7.37.1)
Suggests: gobject-introspection (>= 1.40.0), GTK+2 (>= 2.24.24), \
lcms2 (>= 2.6), LibTIFF (>= 4.0.3), OpenJPEG (>= 1.5.2), Qt4 (>= 4.8.6)
Description: PDF rendering library
EOF
}

build
