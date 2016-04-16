#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=bind-9.10.0-P2.tar.gz
srcdir=bind-9.10.0-P2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make -C lib/dns
make -C lib/isc
make -C lib/bind9
make -C lib/isccfg
make -C lib/lwres
make -C bin/dig
make DESTDIR=$BUILDDIR -C bin/dig install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i), libxml2 (>= 2.9.1), json-c (>= 0.12)
Conflicts: bind (>= 9)
Description: Utilities for querying DNS name servers
EOF
}

build
