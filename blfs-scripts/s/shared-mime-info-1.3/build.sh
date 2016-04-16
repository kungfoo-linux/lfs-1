#!/bin/bash -e
. ../../blfs.comm

build_src() {
# This package does not support parallel build.

srcfil=shared-mime-info-1.3.tar.xz
srcdir=shared-mime-info-1.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make -j1
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), libxml2 (>= 2.9.1)
Description: Shared MIME information database
 The Shared Mime Info package contains a MIME database. This allows central
 updates of MIME information for all supporting applications.
 .
 [update-mime-database]
 assists in adding MIME data to the database.
EOF
}

build
