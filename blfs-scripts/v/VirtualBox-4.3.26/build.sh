#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=VirtualBox-4.3.26.tar.bz2
srcdir=VirtualBox-4.3.26
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: IASL (>= 20141107), cdrtools (>= 3.00)
Recommends:
Suggests:
Description: A general-purpose full virtualizer for x86 hardware
EOF
}

build
