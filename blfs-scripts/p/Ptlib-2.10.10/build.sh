#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ptlib-2.10.10.tar.xz
srcdir=ptlib-2.10.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/ptlib-2.10.10-bison_fixes-1.patch

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

chmod -v 755 $BUILDDIR/usr/lib/libpt.so.2.10.10

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), OpenSSL (>= 1.0.1i), Lua (>= 5.2.3), \
PulseAudio (>= 5.0), SDL (>= 1.2.15), unixODBC (>= 2.3.2)
Description: Portable Tools Library
 PTLib (Portable Tools Library) is a moderately large class library that has
 it's genesis many years ago as PWLib (portable Windows Library), a method to
 product applications to run on both Microsoft Windows and Unix systems. It
 has also been ported to other systems such as Mac OSX, VxWorks and other
 embedded systems. It is supplied mainly to support the OPAL project, but that
 shouldn't stop you from using it in whatever project you have in mind if you
 so desire.
EOF
}

build
