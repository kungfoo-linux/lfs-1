#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=unrarsrc-5.1.7.tar.gz
srcdir=unrar
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make -f makefile
mkdir -pv $BUILDDIR/usr/bin && install -v -m755 unrar $BUILDDIR/usr/bin

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: unarchiver for .rar files
 The UnRar package contains a RAR extraction utility used for extracting files
 from RAR archives. RAR archives are usually created with WinRAR, primarily in
 a Windows environment.
 .
 [unrar]
 uncompresses a RAR archive. For example (extrace file(s) from abc.rar):
 unrar x abc.rar
EOF
}

build
