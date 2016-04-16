#!/bin/bash -e
. ../../blfs.comm

build_src() {
# Note: This package does not support parallel build.

srcfil=json-c-0.12.tar.gz
srcdir=json-c-0.12
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i s/-Werror// Makefile.in

./configure --prefix=/usr \
	--disable-static
make -j1
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a JSON implementation in C
 The JSON-C implements a reference counting object model that allows you to
 easily construct JSON objects in C, output them as JSON formatted strings and
 parse JSON formatted strings back into the C representation of JSON objects.
 .
 [libjson.so]
 contains the JSON-C API functions.
 .
 [libjson-c.so]
 contains the JSON-C API functions.
EOF
}

build
