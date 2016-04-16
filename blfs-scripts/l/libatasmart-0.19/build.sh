#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libatasmart-0.19.tar.xz
srcdir=libatasmart-0.19
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR docdir=/usr/share/doc/libatasmart-0.19 install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: ATA S.M.A.R.T. Disk Health Monitoring Library
 The libatasmart package is a disk reporting library. It only supports a
 subset of the ATA S.M.A.R.T. functionality.
 .
 [skdump]
 is a utility that reports on the status of the disk.
 .
 [sktest]
 is a utility to issue disks tests.
 .
 [libatasmart.so]
 contains the ATA S.M.A.R.T API functions.
EOF
}

build
