#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libical-1.0.tar.gz
srcdir=libical-1.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_BUILD_TYPE=Release \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: iCalendar library implementation in C
 The libical package is an implementation of iCalendar protocols and data
 formats.
 .
 [libical.{so,a}]
 contains the libical API functions.
 .
 [libicalss.{so,a}]
 is a library that allows you to store iCal component data to disk in a
 variety of ways.
 .
 [libicalvcal.{so,a}]
 is a vCard/vCalendar C interface.
EOF
}

build
