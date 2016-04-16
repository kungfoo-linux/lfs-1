#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gegl-0.2.0.tar.bz2
srcdir=gegl-0.2.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/gegl-0.2.0-ffmpeg2-1.patch

./configure --prefix=/usr
LC_ALL=en_US make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: babl (>= 0.1.10)
Recommends: Cairo (>= 1.12.16), Enscript (>= 1.6.6), Exiv2 (>= 0.24), \
FFmpeg (>= 2.3.3), gdk-pixbuf (>= 2.30.8), Graphviz (>= 2.38.0), \
libjpeg-turbo (>= 1.3.1), libpng (>= 1.6.13), librsvg (>= 2.40.3), \
Lua (>= 5.2.3), Pango (>= 1.36.7), Python2 (>= 2.7.8), Ruby (>= 1.8.7), \
SDL (>= 1.2.15), gobject-introspection (>= 1.40.0), Vala (>= 0.24.0)
Description: Generic Graphics Library
EOF
}

build
