#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pth-2.0.7.tar.gz
srcdir=pth-2.0.7
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# Fixes a race condition in the Makefile. It allows you to run make with
# multiple jobs (e.g., make -j4):
sed -i 's#$(LOBJS): Makefile#$(LOBJS): pth_p.h Makefile#' Makefile.in

# Don't add the --enable-pthread parameter to the configure command below 
# else you will overwrite the pthread library and interface header installed 
# by the Glibc package in LFS.
./configure --prefix=/usr \
	--disable-static \
	--mandir=/usr/share/man
make
make DESTDIR=$BUILDDIR install
install -v -m755 -d $BUILDDIR/usr/share/doc/pth-2.0.7
install -v -m644 README PORTING SUPPORT TESTS \
	$BUILDDIR/usr/share/doc/pth-2.0.7

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: The GNU Portable Threads
 The Pth package contains a very portable POSIX/ANSI-C based library for Unix
 platforms which provides non-preemptive priority-based scheduling for
 multiple threads of execution (multithreading) inside event-driven
 applications. All threads run in the same address space of the server
 application, but each thread has its own individual program-counter, run-time
 stack, signal mask and errno variable.
 .
 [libpth.so] contains the API functions used by the GNU Portable Threads 
 Library.
EOF
}

build
