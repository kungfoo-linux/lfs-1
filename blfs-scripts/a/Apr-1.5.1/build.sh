#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=apr-1.5.1.tar.bz2
srcdir=apr-1.5.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--with-installbuilddir=/usr/share/apr-1/build
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Apache Portable Runtime library
 The Apache Portable Runtime (APR) is a supporting library for the Apache web
 server. It provides a set of application programming interfaces (APIs) that
 map to the underlying Operating System (OS). Where the OS doesn't support a
 particular function, APR will provide an emulation. Thus programmers can use
 the APR to make a program portable across different platforms.
 .
 [apr-1-config]
 is a shell script used to retrieve information about the apr library in the
 system. It is typically used to compile and link against the library.
 .
 [libapr-1.so]
 is the Apache Portable Runtime library. 
EOF
}

build
