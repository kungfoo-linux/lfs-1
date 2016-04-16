#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libburn-1.3.8.tar.gz
srcdir=libburn-1.3.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr --disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: library to provide CD/DVD writing functions
 libburn is a library for writing preformatted data onto optical media: CD,
 DVD and BD (Blu-Ray).
 .
 [cdrskin] burns preformatted data to CD, DVD, and BD via libburn. 
EOF
}

build
