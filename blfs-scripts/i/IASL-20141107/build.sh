#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=acpica-unix-20141107.tar.gz
srcdir=acpica-unix-20141107
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Intel ACPI compiler
EOF
}

build
