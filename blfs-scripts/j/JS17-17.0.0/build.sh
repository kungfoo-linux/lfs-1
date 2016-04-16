#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=mozjs17.0.0.tar.gz
srcdir=mozjs17.0.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/js/src

./configure --prefix=/usr \
	--enable-readline \
	--enable-threadsafe \
	--with-system-ffi \
	--with-system-nspr
make
make DESTDIR=$BUILDDIR install

find $BUILDDIR/usr/include/js-17.0/ \
	$BUILDDIR/usr/lib/libmozjs-17.0.a \
	$BUILDDIR/usr/lib/pkgconfig/mozjs-17.0.pc \
	-type f -exec chmod -v 644 {} \;

cleanup_src ../../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libffi (>= 3.1), NSPR (>= 4.10.7), Python2 (>= 2.7.8)
Description: Mozilla's JavaScript engine
 .
 [js17]
 provides a command line interface to the JavaScript engine.
 .
 [js17-config]
 is used to find out JS compiler and linker flags.
 .
 [libmozjs-17.0.so]
 contains the Mozilla JavaScript API functions. 
EOF
}

build
