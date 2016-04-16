#!/bin/bash -e
. ../../blfs.comm

# NOTE: This package overwrites the version of traceroute that was installed
# in the inetutils package in LFS. This version is more powerful and allows
# many more options than the standard version.

build_src() {
srcfil=traceroute-2.0.20.tar.gz
srcdir=traceroute-2.0.20
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make DESTDIR=$BUILDDIR prefix=/usr install
mv $BUILDDIR/usr/bin/ $BUILDDIR/bin
ln -sv -f traceroute $BUILDDIR/bin/traceroute6
ln -sv -f traceroute.8 $BUILDDIR/usr/share/man/man8/traceroute6.8

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Traces the route taken by packets over an IPv4/IPv6 network
 The Traceroute package contains a program which is used to display the
 network route that packets take to reach a specified host. This is a standard
 network troubleshooting tool. If you find yourself unable to connect to
 another system, traceroute can help pinpoint the problem.
EOF
}

build
