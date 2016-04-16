#!/bin/bash -e
. ../../../blfs.comm

# To build Python 2 module
build_with_python2() {
mkdir python2
pushd python2
../configure --prefix=/usr \
	--with-python=/usr/bin/python
make
make DESTDIR=$BUILDDIR install
popd
}

# To build Python 3 module
build_with_python3() {
mkdir python3
pushd python3
../configure --prefix=/usr \
	--with-python=/usr/bin/python3
make
make DESTDIR=$BUILDDIR install
popd
}

build_src() {
python_module_setting
srcfil=pygobject-3.12.2.tar.xz
srcdir=pygobject-3.12.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

build_with_python2
build_with_python3

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: gobject-introspection (>= 1.40.0), \
python-module-py2cairo (>= 1.10.0), python-module-pycairo (>= 1.10.0)
Description: Python bindings to the GObject class from GLib
EOF
}

build
