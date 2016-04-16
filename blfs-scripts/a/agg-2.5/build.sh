#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=agg-2.5.tar.gz
srcdir=agg-2.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's:  -L@x_libraries@::' src/platform/X11/Makefile.am
sed -i '/^AM_C_PROTOTYPES/d'   configure.in

bash autogen.sh --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: SDL (>= 1.2.15), Xorg-lib (>= 7.7)
Description: Anti-Grain Geometry graphical rendering engine
 The Anti-Grain Geometry (AGG) package contains a general purpose C++
 graphical toolkit. It can be used in many areas of computer programming where
 high quality 2D graphics is an essential part of the project.
EOF
}

build
