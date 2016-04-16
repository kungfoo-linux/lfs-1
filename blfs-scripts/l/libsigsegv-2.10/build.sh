#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libsigsegv-2.10.tar.gz
srcdir=libsigsegv-2.10
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--enable-shared \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Library for handling page faults in user mode
 This is a library for handling page faults in user mode. A page fault occurs
 when a program tries to access to a region of memory that is currently not
 available. Catching and handling a page fault is a useful technique for
 implementing pageable virtual memory, memory-mapped access to persistent
 databases, generational garbage collectors, stack overflow handlers, and
 distributed shared memory.
 .
 [libsigsegv.so]
 is a library for handling page faults in user mode.
EOF
}

build
