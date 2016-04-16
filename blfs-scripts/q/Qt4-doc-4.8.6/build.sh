#!/bin/bash -e
ARCHITECTURE=all
. ../../blfs.comm

build_src() {
srcfil=qt-everywhere-opensource-src-4.8.6.tar.gz
srcdir=qt-everywhere-opensource-src-4.8.6
tar -xf $BLFSSRC/$PKGLETTER/Qt4-4.8.6/$srcfil
cd $srcdir

export QT4DIR=/opt/qt-4.8.6

mkdir -pv $BUILDDIR/$QT4DIR
cp -r demos doc examples $BUILDDIR/$QT4DIR

cd .. && rm -rf $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Qt toolkit documents
EOF
}

build
