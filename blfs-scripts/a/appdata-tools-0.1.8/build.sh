#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=appdata-tools-0.1.8.tar.xz
srcdir=appdata-tools-0.1.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: appstream-glib (>= 0.3.0), gobject-introspection (>= 1.40.0), \
libxml2 (>= 2.9.1)
Description: AppData validation tool
 appdata-tools contains a command line program designed to validate AppData
 application descriptions for standards compliance and to the style guide.
EOF
}

build
