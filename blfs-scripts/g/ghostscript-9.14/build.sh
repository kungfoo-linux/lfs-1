#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ghostscript-9.14.tar.bz2
srcdir=ghostscript-9.14
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/ZLIBDIR=src/ZLIBDIR=$includedir/' configure.ac configure
rm -rf expat freetype lcms2 jpeg libpng zlib

./configure --prefix=/usr \
	--disable-compile-inits \
	--enable-dynamic \
	--with-system-libtiff
make
make so
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR soinstall

install -v -m644 base/*.h $BUILDDIR/usr/include/ghostscript
ln -sv ghostscript $BUILDDIR/usr/include/ps
mkdir -pv $BUILDDIR/usr/share/doc/
ln -sfv ../ghostscript/9.14/doc $BUILDDIR/usr/share/doc/ghostscript-9.14

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/ghostscript-fonts-std-8.11.tar.gz \
	-C $BUILDDIR/usr/share/ghostscript --no-same-owner
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/gnu-gs-fonts-other-6.0.tar.gz \
	-C $BUILDDIR/usr/share/ghostscript --no-same-owner

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: FreeType (>= 2.5.3), libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), \
LibTIFF (>= 4.0.3), lcms2 (>= 2.6), Cairo (>= 1.12.16), Cups (>= 1.7.5), \
Fontconfig (>= 2.11.1), GTK+2 (>= 2.24.24), libidn (>= 1.29), \
libpaper (>= 1.1.24)
Description: A PostScript interpreter and renderer
 Ghostscript is a versatile processor for PostScript data with the ability to
 render PostScript to different targets. It used to be part of the cups
 printing stack, but is no longer used for that.
 .
 [gs]
 is an interpreter for Adobe Systems' PostScript(tm) and Portable Document
 Format (PDF).
 .
 [libgs.so]
 provides Ghostscript functionality to other programs, such as GSView,
 ImageMagick, and libspectre.
EOF
}

set_deb_def() {
POSTINST_CONF_DEF='fc-cache -v /usr/share/ghostscript/fonts/'
}

build
