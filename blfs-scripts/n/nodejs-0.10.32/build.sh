#!/bin/bash -e
. ../../blfs.comm

# NOTE: Python 2.6 or 2.7 is required to build from source tarballs.

build_src() {
srcfil=node-v0.10.32.tar.gz
srcdir=node-v0.10.32
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make $JOBS
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Node.js event-based server-side javascript engine
 Node.js is a platform built on Chrome's JavaScript runtime for easily
 building fast, scalable network applications. Node.js uses an event-driven,
 non-blocking I/O model that makes it lightweight and efficient, perfect for
 data-intensive real-time applications that run across distributed devices.
EOF
}

build
