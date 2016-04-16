#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=gmime-2.6.20.tar.xz
srcdir=gmime-2.6.20
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--enable-smime
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0), libgpg-error (>= 1.13), gobject-introspection (>= 1.40.0), Vala (>= 0.24.0), GPGME (>= 1.5.1)
Description: library for creating and parsing MIME messages
 The GMime package contains a set of utilities for parsing and creating
 messages using the Multipurpose Internet Mail Extension (MIME) as defined by
 the applicable RFCs. See the GMime web site for the RFCs resourced. This is
 useful as it provides an API which adheres to the MIME specification as
 closely as possible while also providing programmers with an extremely easy
 to use interface to the API functions.
 .
 [libgmime-2.6.so]
 contains API functions used by programs that need to comply to the MIME
 standards.
EOF
}

build
