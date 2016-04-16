#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=opus-1.1.tar.gz
srcdir=opus-1.1
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
Description: An audio codec for use in low-delay speech and audio communication
 Opus is a lossy audio compression format developed by the Internet
 Engineering Task Force (IETF) that is particularly suitable for interactive
 speech and audio transmission over the Internet. This package provides the
 Opus development library and headers.
EOF
}

build
