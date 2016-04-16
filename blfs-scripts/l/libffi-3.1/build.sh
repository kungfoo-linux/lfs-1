#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libffi-3.1.tar.gz
srcdir=libffi-3.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -e '/^includesdir/ s:$(libdir)/@PACKAGE_NAME@-@PACKAGE_VERSION@/include:$(includedir):' \
    -i include/Makefile.in
sed -e '/^includedir/ s:${libdir}/@PACKAGE_NAME@-@PACKAGE_VERSION@/include:@includedir@:' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in
./configure --prefix=/usr --disable-static

make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Foreign Function Interface library
 The libffi library provides a portable, high level programming interface to
 various calling conventions. This allows a programmer to call any function
 specified by a call interface description at run time. 
 .
 [libffi.so] contains the libffi API functions. 
EOF
}

build
