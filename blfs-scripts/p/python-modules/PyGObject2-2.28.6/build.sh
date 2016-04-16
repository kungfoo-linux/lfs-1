#!/bin/bash -e
. ../../../blfs.comm

build_src() {
python_module_setting
srcfil=pygobject-2.28.6.tar.xz
srcdir=pygobject-2.28.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/pygobject-2.28.6-fixes-1.patch
./configure --prefix=/usr \
	--disable-introspection
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8), GLib (>= 2.40.0), \
python-module-py2cairo (>= 1.10.0)
Description: Python 2 bindings to the GObject class from GLib
EOF
}

build
