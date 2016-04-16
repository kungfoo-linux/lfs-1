#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xfconf-4.10.0.tar.bz2
srcdir=xfconf-4.10.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

remove_perl_files
cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), libxfce4util (>= 4.10.0), \
perl-module-glib (>= 1.305)
Description: the configuration storage system for Xfce
EOF
}

#build
remove_perl_files
