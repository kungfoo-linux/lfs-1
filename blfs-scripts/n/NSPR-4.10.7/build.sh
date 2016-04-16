#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=nspr-4.10.7.tar.gz
srcdir=nspr-4.10.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir/nspr

sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in
sed -i 's#$(LIBRARY) ##' config/rules.mk

./configure --prefix=/usr \
	--with-mozilla \
	--with-pthreads \
	$([ $(uname -m) = x86_64 ] && echo --enable-64bit)
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Netscape Portable Runtime
 Netscape Portable Runtime (NSPR) provides a platform-neutral API for system
 level and libc like functions.
 .
 [nspr-config] provides compiler and linker options to other packages that 
 use NSPR.
 .
 [libnspr4.so] contains functions that provide platform independence for 
 non-GUI operating system facilities such as threads, thread synchronization,
 normal file and network I/O, interval timing and calendar time, basic memory
 management and shared library linking.
 .
 [libplc4.so] contains functions that implement many of the features offered 
 by libnspr4.
 .
 [libplds4.so] contains functions that provide data structures. 
EOF
}

build
