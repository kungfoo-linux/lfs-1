#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=polkit-kde-agent-1-0.99.0.tar.bz2
srcdir=polkit-kde-agent-1-0.99.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/polkit-kde-agent-1-0.99.0-remember_password-1.patch

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: polkit-qt (>= 0.112.0), kdelibs (>= 4.14.1)
Description: daemon providing a polkit authentication UI for KDE
EOF
}

build
