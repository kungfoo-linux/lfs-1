#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sharutils-4.14.tar.xz
srcdir=sharutils-4.14
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
Description: the GNU shar utilities for packaging and unpackaging shell archives
 The Sharutils package contains utilities that can create 'shell' archives.
 .
 [shar]
 creates "shell archives" (or shar files) which are in text format and can be
 mailed.
 .
 [unshar]
 unpacks a shar file.
 .
 [uudecode]
 reads a file (or by default the standard input) and writes an encoded version
 to the standard output. The encoding uses only printing ASCII characters.
 .
 [uuencode]
 reads a file (or by default the standard input) and decodes the uuencoded
 version to the standard output.
EOF
}

build
