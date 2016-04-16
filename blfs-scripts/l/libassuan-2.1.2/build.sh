#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libassuan-2.1.2.tar.bz2
srcdir=libassuan-2.1.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libgpg-error (>= 1.13)
Description: IPC library for the GnuPG components
 The libassuan package contains an inter process communication library used by
 some of the other GnuPG related packages. libassuan's primary use is to allow
 a client to interact with a non-persistent server. libassuan is not, however,
 limited to use with GnuPG servers and clients. It was designed to be flexible
 enough to meet the demands of many transaction based environments with
 non-persistent servers.
 .
 [libassuan.so] is an inter process communication library which implements 
 the Assuan protocol. 
EOF
}

build
