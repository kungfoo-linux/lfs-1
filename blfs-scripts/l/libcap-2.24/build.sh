#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libcap-2.24.tar.xz
srcdir=libcap-2.24
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's:LIBDIR:PAM_&:g' pam_cap/Makefile
make DESTDIR=$BUILDDIR prefix=/usr \
	SBINDIR=$BUILDDIR/sbin \
	PAM_LIBDIR=$BUILDDIR/lib \
	RAISE_SETFCAP=no install

chmod -v 755 $BUILDDIR/usr/lib/libcap.so &&
mv -v        $BUILDDIR/usr/lib/libcap.so.* $BUILDDIR/lib &&
ln -sfv ../../lib/libcap.so.2 $BUILDDIR/usr/lib/libcap.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Linux-PAM (>= 1.1.8)
Description: Library for getting and setting POSIX.1e capabilities
 The Libcap package implements the user-space interfaces to the POSIX 1003.1e
 capabilities available in Linux kernels. These capabilities are a
 partitioning of the all powerful root privilege into a set of distinct
 privileges.
 .
 The libcap package was installed in LFS, but if PAM support is desired, it
 needs to be reinstalled after PAM is built. 
 .
 [capsh] is a shell wrapper to explore and constrain capability support.
 .
 [getcap] examines file capabilities.
 .
 [getpcaps] displays the capabilities on the queried process(es).
 .
 [setcap] sets file file capabilities.
 .
 [libcap.{so,a}] contains the libcap API functions. 
EOF
}

build
