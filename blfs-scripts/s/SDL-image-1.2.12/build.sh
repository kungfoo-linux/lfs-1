#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=SDL_image-1.2.12.tar.gz
srcdir=SDL_image-1.2.12
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
Depends: SDL (>= 1.2.15)
Recommends: libjpeg-turbo (>= 1.3.1), LibTIFF (>= 4.0.3), \
libpng (>= 1.6.13), libwebp (>= 0.4.1)
Description: Image loading library for SDL
 SDL_image is an image loading library that is used with the SDL library, and
 almost as portable. It allows a programmer to use multiple image formats
 without having to code all the loading and conversion algorithms themselves.
 .
 SDL_image loads images as SDL surfaces, and supports the following formats:
 BMP, GIF, JPEG, LBM, PCX, PNG, PNM, TGA, TIFF, WEBP, XCF, XPM, XV.
 .
 As of SDL_image 1.2.5, JPEG, PNG, TIFF, and WEBP image loading libraries are
 dynamically loaded, so if you don't need to load those formats, you don't
 need to include those shared libraries.
EOF
}

build
