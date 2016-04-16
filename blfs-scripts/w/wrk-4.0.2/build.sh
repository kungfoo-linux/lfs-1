#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=wrk-4.0.2.tar.gz
srcdir=wrk-4.0.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
mkdir -p $BUILDDIR/usr/bin
cp wrk $BUILDDIR/usr/bin

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a HTTP benchmarking tool
 wrk is a modern HTTP benchmarking tool capable of generating significant
 load when run on a single multi-core CPU. It combines a multithreaded
 design with scalable event notification systems such as epoll and kqueue.
 .
 Basic Usage:
 wrk -t4 -c400 -d30s http://127.0.0.1:8080/index.html
 .
 This runs a benchmark for 30 seconds, using 4 threads, and keeping
 400 HTTP connections open.
EOF
}

build
