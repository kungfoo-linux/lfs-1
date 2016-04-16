#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=apr-util-1.5.3.tar.bz2
srcdir=apr-util-1.5.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--with-apr=/usr \
	--with-gdbm=/usr \
	--with-openssl=/usr \
	--with-crypto
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Apr (>= 1.5.1), OpenSSL (>= 1.0.1i)
Description: Apache Portable Runtime Utility library
 The Apache Portable Runtime Utility Library provides a predictable and
 consistent interface to underlying client library interfaces. This
 application programming interface assures predictable if not identical
 behaviour regardless of which libraries are available on a given platform.
 .
 [libaprutil-1.so]
 contains functions that provide a predictable and consistent interface to
 underlying client library interfaces. 
EOF
}

build
