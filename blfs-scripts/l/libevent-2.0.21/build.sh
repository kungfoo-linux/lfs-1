#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libevent-2.0.21-stable.tar.gz
srcdir=libevent-2.0.21-stable
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: asynchronous event notification library
 libevent is an asynchronous event notification software library. The libevent
 API provides a mechanism to execute a callback function when a specific event
 occurs on a file descriptor or after a timeout has been reached. Furthermore,
 libevent also supports callbacks due to signals or regular timeouts.
EOF
}

build
