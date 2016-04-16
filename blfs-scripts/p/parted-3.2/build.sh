#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=parted-3.2.tar.xz
srcdir=parted-3.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make -C doc html
makeinfo --html -o doc/html doc/parted.texi
makeinfo --plaintext -o doc/parted.txt doc/parted.texi
make DESTDIR=$BUILDDIR install
install -v -m755 -d $BUILDDIR/usr/share/doc/parted-3.2/html
install -v -m644 doc/html/* $BUILDDIR/usr/share/doc/parted-3.2/html
install -v -m644 doc/{FAT,API,parted.{txt,html}} \
	$BUILDDIR/usr/share/doc/parted-3.2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: LVM2 (>= 2.02.111)
Description: the GNU disk partition manipulation program
 .
 [parted]
 is a partition manipulation program.
 .
 [partprobe]
 informs the OS of partition table changes.
 .
 [libparted.so]
 contains the Parted API functions. 
EOF
}

build
