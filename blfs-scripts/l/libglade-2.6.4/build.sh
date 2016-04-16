#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libglade-2.6.4.tar.bz2
srcdir=libglade-2.6.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '/DG_DISABLE_DEPRECATED/d' glade/Makefile.in

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libxml2 (>= 2.9.1), GTK+2 (>= 2.24.24), Python2 (>= 2.7.8)
Description: library to load .glade files at runtime
 .
 [libglade-convert]
 is used to convert old Glade interface files to Glade-2.0 standards.
 .
 [libglade-2.0.so]
 contain the functions necessary to load Glade interface files.
EOF
}

build
