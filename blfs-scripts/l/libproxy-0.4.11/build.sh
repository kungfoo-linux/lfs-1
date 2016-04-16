#!/bin/bash -e
. ../../blfs.comm

build_src() {
# use CMake to build.

srcfil=libproxy-0.4.11.tar.gz
srcdir=libproxy-0.4.11
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_CXX_FLAGS="-O2" \
	-DCMAKE_C_FLAGS="-O2" \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), Python2 (>= 2.7.8)
Description: automatic proxy configuration management library
 libproxy is a lightweight library which makes it easy to develop
 applications proxy-aware with a simple and stable API.
EOF
}

build
