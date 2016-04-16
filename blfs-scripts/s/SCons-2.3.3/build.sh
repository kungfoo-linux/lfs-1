#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=scons-2.3.3.tar.gz
srcdir=scons-2.3.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

python setup.py install --prefix=$BUILDDIR/usr  \
	--standard-lib \
	--optimize=1 \
	--install-data=$BUILDDIR/usr/share

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8)
Description: replacement for make
 SCons is a tool for building software (and other files) implemented in
 Python.
 .
 [scons]
 is a software construction tool.
 .
 [sconsign]
 prints SCons .sconsign file information.
 .
 [scons-time]
 generates and displays SCons timing information.
EOF
}

build
