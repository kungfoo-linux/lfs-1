#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=epdfview-0.1.8.tar.bz2
srcdir=epdfview-0.1.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# The patch does three things: fixes compiling with glib-2.32 or greater,
# corrects red appearing as blue with recent versions of poppler, and allows
# the application to compile when Cups-1.7.5 has been installed:
patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/epdfview-0.1.8-fixes-1.patch

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Poppler (>= 0.26.4), GTK+2 (>= 2.24.24)
Suggests: Cups (>= 1.7.5)
Description: Lightweight pdf viewer based on poppler libs
 ePDFView is a free standalone lightweight PDF document viewer using Poppler
 and GTK+ libraries. It is a good replacement for Evince as it does not rely
 upon GNOME libraries.
EOF
}

build
