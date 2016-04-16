#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=alsa-oss-1.0.28.tar.bz2
srcdir=alsa-oss-1.0.28
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
Depends: alsa-lib (>= 1.0.28)
Description: the ALSA OSS compatibility library
EOF
}

build
