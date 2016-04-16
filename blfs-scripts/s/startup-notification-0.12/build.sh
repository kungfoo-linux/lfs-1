#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=startup-notification-0.12.tar.gz
srcdir=startup-notification-0.12
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/usr/share/doc/startup-notification-0.12
install -v -m644 -D doc/startup-notification.txt \
	$BUILDDIR/usr/share/doc/startup-notification-0.12

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7), xcb-util (>= 0.3.9)
Description: library for program launch feedback
 The startup-notification package contains startup-notification libraries.
 These are useful for building a consistent manner to notify the user through
 the cursor that the application is loading.
EOF
}

build
