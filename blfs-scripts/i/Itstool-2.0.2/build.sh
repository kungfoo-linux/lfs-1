#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=itstool-2.0.2.tar.bz2
srcdir=itstool-2.0.2
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
Depends: docbook-xml (>= 4.5), Python2 (>= 2.7.8)
Description: tool for translating XML documents with PO files
 Itstool extracts messages from XML files and outputs PO template files, then
 merges translations from MO files to create translated XML files. It
 determines what to translate and how to chunk it into messages using the W3C
 Internationalization Tag Set (ITS).
 .
 [itstool]
 is used to create translated XML files.
EOF
}

build
