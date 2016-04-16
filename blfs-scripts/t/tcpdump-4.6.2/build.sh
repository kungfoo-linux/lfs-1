#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=tcpdump-4.6.2.tar.gz
srcdir=tcpdump-4.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

rm -f $BUILDDIR/usr/sbin/tcpdump.4.6.2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libpcap (>= 1.6.2), OpenSSL (>= 1.0.1i)
Description: command-line network traffic analyzer
 Tcpdump is a tool for network monitoring and data acquisition. This software
 was originally developed by the Network Research Group at the Lawrence
 Berkeley National Laboratory. Tcpdump uses libpcap. so, before building
 tcpdump, you must first retrieve and build libpcap.
EOF
}

build
