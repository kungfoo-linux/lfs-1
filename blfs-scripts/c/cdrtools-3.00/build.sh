#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=cdrtools-3.00.tar.gz
srcdir=cdrtools-3.00
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make DESTDIR=$BUILDDIR INS_BASE=/usr install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Highly portable CD/DVD/BluRay command line recording software
EOF
}

build
