#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libzeitgeist-0.3.18.tar.gz
srcdir=libzeitgeist-0.3.18
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: GLib (>= 2.40.0)
Description: library to access Zeitgeist
 The libzeitgeist package contains a client library used to access and manage
 the Zeitgeist event log from languages such as C and Vala. Zeitgeist is a
 service which logs the user's activities and events (files opened, websites
 visited, conversations hold with other people, etc.) and makes the relevant
 information available to other applications.
 .
 [libzeitgeist-1.0.so]
 contains the libzeitgeist API functions.
EOF
}

build
