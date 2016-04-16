#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=ldns-1.6.17.tar.gz
srcdir=ldns-1.6.17
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--with-drill
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i), CA (= 7.6)
Description: library for DNS programming
 ldns is a fast DNS library with the goal to simplify DNS programming and to
 allow developers to easily create software conforming to current RFCs and
 Internet drafts. This packages also includes the drill tool.
EOF
}

build
