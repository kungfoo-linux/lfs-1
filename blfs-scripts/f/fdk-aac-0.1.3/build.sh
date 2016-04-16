#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=fdk-aac-0.1.3.tar.gz
srcdir=fdk-aac-0.1.3
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
Description: the Fraunhofer FDK AAC library
 fdk-aac package provides the Fraunhofer FDK AAC library, which is purported
 to be a high quality Advanced Audio Coding implementation.
EOF
}

build
