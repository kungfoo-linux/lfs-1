#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libaio-0.3.110.tar.gz
srcdir=libaio-0.3.110
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make prefix=$BUILDDIR/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Linux kernel AIO access library.
 This library enables userspace to use Linux kernel asynchronous I/O
 system calls, important for the performance of databases and other
 advanced applications.
EOF
}

build
