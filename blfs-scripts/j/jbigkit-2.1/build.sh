#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=jbigkit-2.1.tar.gz
srcdir=jbigkit-2.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
mkdir -pv $BUILDDIR/usr/{bin,include,lib}
cp -v libjbig/{libjbig.a,libjbig85.a} $BUILDDIR/usr/lib
cp -v libjbig/{jbig85.h,jbig_ar.h,jbig.h} $BUILDDIR/usr/include
cp -v pbmtools/{pbmtojbg,jbgtopbm,pbmtojbg85,jbgtopbm85} $BUILDDIR/usr/bin

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: JBIG1 lossless image compression tools
 JBIG is a highly effective lossless compression algorithm for bi-level images
 (one bit per pixel), which is particularly suitable for scanned document
 pages.
EOF
}

build
