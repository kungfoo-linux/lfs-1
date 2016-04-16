#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=openldap-2.4.39.tgz
srcdir=openldap-2.4.39
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/openldap-2.4.39-blfs_paths-1.patch
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/openldap-2.4.39-symbol_versions-1.patch
autoconf

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--enable-dynamic \
	--disable-debug \
	--disable-slapd \
	--without-cyrus-sasl
make depend
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Recommends: OpenSSL (>= 1.0.1i)
Description: open source implementation of the Lightweight Directory Access Protocol
EOF
}

build
