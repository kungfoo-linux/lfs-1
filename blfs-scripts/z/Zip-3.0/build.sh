#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=zip30.tgz
srcdir=zip30
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make -f unix/Makefile generic_gcc
make prefix=$BUILDDIR/usr MANDIR=$BUILDDIR/usr/share/man/man1 \
	-f unix/Makefile install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: File compression program
 The Zip package contains Zip utilities. These are useful for compressing
 files into ZIP archives.
 .
 [zip] compresses files into a ZIP archive.
 .
 [zipcloak] is a utility to encrypt and decrypt a ZIP archive.
 .
 [zipnote] reads or writes comments stored in a ZIP file.
 .
 [zipsplit] is a utility to split ZIP files into smaller files. 
EOF
}

build
