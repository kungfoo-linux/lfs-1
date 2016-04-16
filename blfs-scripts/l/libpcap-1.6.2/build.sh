#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libpcap-1.6.2.tar.gz
srcdir=libpcap-1.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# If you want to build with blueZ, uncomment the following line:
#patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/libpcap-1.6.2-enable_bluetooth-1.patch

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libnl (>= 3.2.25), libusb (>= 1.0.19)
Description: system interface for user-level packet capture
 libpcap provides functions for user-level packet capture, used in low-level
 network monitoring.
 .
 [pcap-config]
 provides configuration information for libpcap.
 .
 [libpcap.{a,so}]
 are libraries used for user-level packet capture.
EOF
}

build
