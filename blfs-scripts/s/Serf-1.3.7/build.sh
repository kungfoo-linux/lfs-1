#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package use SCons to build.

srcfil=serf-1.3.7.tar.bz2
srcdir=serf-1.3.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "/Append/s:RPATH=libdir,::"   SConstruct
sed -i "/Default/s:lib_static,::"    SConstruct
sed -i "/Alias/s:install_static,::"  SConstruct
scons PREFIX=/usr
scons PREFIX=$BUILDDIR/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Apr-Util (>= 1.5.3), OpenSSL (>= 1.0.1i)
Description: high-performance asynchronous HTTP client library
 The Serf package contains a C-based HTTP client library built upon the Apache
 Portable Runtime (APR) library. It multiplexes connections, running the
 read/write communication asynchronously. Memory copies and transformations
 are kept to a minimum to provide high performance operation.
 .
 [libserf-1.so]
 contains the Serf API functions.
EOF
}

build
