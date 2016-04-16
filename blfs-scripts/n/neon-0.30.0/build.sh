#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=neon-0.30.0.tar.gz
srcdir=neon-0.30.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-shared \
	--disable-static \
	--with-ssl=gnutls \
	--with-libxml2
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GnuTLS (>= 3.3.7), libxml2 (>= 2.9.1)
Description: HTTP and WebDAV client library
 neon is an HTTP and WebDAV client library, with a C language API.
 .
 [libneon.so]
 is used as a high-level interface to common HTTP and WebDAV methods.
EOF
}

build
