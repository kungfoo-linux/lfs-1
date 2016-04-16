#!/bin/bash -e
. ../../../blfs.comm

# To build D-Bus Python as the Python 2 module
build_with_python2() {
mkdir python2
pushd python2

PYTHON=/usr/bin/python \
../configure --prefix=/usr \
	--docdir=/usr/share/doc/dbus-python-1.2.0
make
make DESTDIR=$BUILDDIR install

popd
}

# To build D-Bus Python as the Python 3 module
build_with_python3() {
mkdir python3
pushd python3

PYTHON=/usr/bin/python3 \
../configure --prefix=/usr \
	--docdir=/usr/share/doc/dbus-python-1.2.0
make
make DESTDIR=$BUILDDIR install

popd
}

build_src() {
python_module_setting
srcfil=dbus-python-1.2.0.tar.gz
srcdir=dbus-python-1.2.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

build_with_python2
build_with_python3

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: dbus-glib (>= 0.102), Python2 (>= 2.7.8)
Recommends: Python3 (>= 3.4.1)
Description: Python bindings to the D-Bus
EOF
}

build
