#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libisoburn-1.3.8.tar.gz
srcdir=libisoburn-1.3.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--enable-pkg-check-modules
make
make DESTDIR=$BUILDDIR install
rm -f $BUILDDIR/usr/share/info/dir

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libburn (>= 1.3.8), libisofs (>= 1.3.8)
Description: a frontend for libburn and libisofs to creat ISO-9660 filesystems
 libisoburn is a frontend for libraries libburn and libisofs which enables
 creation and expansion of ISO-9660 filesystems on all CD/DVD/BD media
 supported by libburn. This includes media like DVD+RW, which do not support
 multi-session management on media level and even plain disk files or block
 devices. 
 .
 [osirrox] is a symbolic link to xorriso that copies files from ISO image 
 to a disk filesystem.
 .
 [xorrecord] is a symbolic link to xorriso that provides a cdrecord type 
 user interface.
 .
 [xorriso] is a program to create, load, manipulate, read, and write 
 ISO 9660 filesystem images with Rock Ridge extensions.
 .
 [xorrisofs] is a symbolic link to xorriso that that provides a mkisofs type 
 user interface.
 .
 [libisoburn.so] contains the libisoburn API functions. 
EOF
}

build
