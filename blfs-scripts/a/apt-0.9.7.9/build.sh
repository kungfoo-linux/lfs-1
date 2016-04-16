#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=apt-0.9.7.9.tar.xz
srcdir=apt-0.9.7.9
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--localstatedir=/var
make -j1

mkdir -pv $BUILDDIR/usr/{bin,lib/apt,share/man/man8}
mkdir -pv $BUILDDIR/etc/apt/{apt.conf.d,preferences.d}

cp -v bin/apt-*       $BUILDDIR/usr/bin
cp -pv bin/libapt-*  $BUILDDIR/usr/lib
cp -rpv bin/methods   $BUILDDIR/usr/lib/apt
cp -v docs/examples/* $BUILDDIR/etc/apt
cp -v docs/apt.8      $BUILDDIR/usr/share/man/man8

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dpkg (>= 1.16), cURL (>= 7.37.1)
Description: commandline package manager
 This package provides commandline tools for searching and managing as well
 as querying information about packages as a low-level access to all features
 of the libapt-pkg library.
EOF
}

build
