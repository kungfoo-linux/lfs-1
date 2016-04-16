#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxcb-1.11.tar.bz2
srcdir=libxcb-1.11
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed "s/pthread-stubs//" -i configure

./configure $XORG_CONFIG \
	--enable-xinput \
	--docdir='${datadir}'/doc/libxcb-1.11
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libXau (>= 1.0.8), xcb-proto (= 1.11), libXdmcp (>= 1.1.1)
Description: A C binding to the X11 protocol
 The libxcb package provides an interface to the X Window System protocol,
 which replaces the current Xlib interface. Xlib can also use XCB as a
 transport layer, allowing software to make requests and receive responses
 with both.
 .
 [libxcb.so]
 is an interface to the X Window System protocol.
EOF
}

build
