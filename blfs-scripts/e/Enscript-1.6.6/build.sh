#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=enscript-1.6.6.tar.gz
srcdir=enscript-1.6.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc/enscript \
	--localstatedir=/var \
	--with-media=Letter
make

pushd docs
makeinfo --plaintext -o enscript.txt enscript.texi
popd

make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: A plain ASCII to PostScript converter
 Enscript converts ASCII text files to PostScript, HTML, RTF, ANSI and
 overstrikes.
 .
 NOTE:
 Enscript cannot convert UTF-8 encoded text to PostScript. The issue is
 discussed in detail in the Needed Encoding Not a Valid Option section of the
 Locale Related Issues page. The solution is to use paps-0.6.8, instead of
 Enscript, for converting UTF-8 encoded text to PostScript.
EOF
}

build
