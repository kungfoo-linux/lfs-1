#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=sqlite-autoconf-3080600.tar.gz
srcdir=sqlite-autoconf-3080600
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
	-DSQLITE_ENABLE_COLUMN_METADATA=1 \
	-DSQLITE_ENABLE_UNLOCK_NOTIFY=1 \
	-DSQLITE_SECURE_DELETE=1"
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: command line interface for SQLite 
 The SQLite package is a software library that implements a self-contained, 
 serverless, zero-configuration, transactional SQL database engine.
 .
 [sqlite3] A terminal-based front-end to the SQLite library that can 
 evaluate queries interactively and display the results.
 .
 [libsqlite3.so] contains the SQLite API functions. 
EOF
}

build
