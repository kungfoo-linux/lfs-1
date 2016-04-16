#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsndfile-1.0.25.tar.gz
srcdir=libsndfile-1.0.25
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install
make DESTDIR=$BUILDDIR htmldocdir=/usr/share/doc/libsndfile-1.0.25 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: alsa-lib (>= 1.0.28), FLAC (>= 1.3.0), libogg (>= 1.3.2), \
libvorbis (>= 1.3.4), SQLite (>= 3.8.6)
Description: Library for reading/writing audio files
EOF
}

build
