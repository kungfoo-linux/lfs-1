#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=compface-1.5.2.tar.gz
srcdir=compface-1.5.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/compface-1.5.2-enable-shared.patch
./configure --prefix=$BUILDDIR/usr \
	--mandir=$BUILDDIR/usr/share/man
make
make install

install -m755 -v xbm2xface.pl $BUILDDIR/usr/bin

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library and tools for handling X-Face data
 Compface provides utilities and a library to convert from/to X-Face format, a
 48x48 bitmap format used to carry thumbnails of email authors in a mail
 header.
 .
 [compface]
 is a filter for generating highly compressed representations of 48x48x1 face
 image files.
 .
 [uncompface]
 is an inverse filter which performs an inverse transformation with no loss of
 data.
 .
 [xbm2xface.pl]
 is a script to generate xfaces.
 .
 libcompface.{so,a}
 allows the compression and decompression algorithms to be used in other
 programs such as MTAs.
EOF
}

build
