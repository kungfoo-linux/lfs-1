#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=iso-codes-3.56.tar.xz
srcdir=iso-codes-3.56
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
Description: ISO code lists and translations
 The ISO Codes package contains a list of country, language and currency names
 and it is used as a central database for accessing this data.
EOF
}

build
