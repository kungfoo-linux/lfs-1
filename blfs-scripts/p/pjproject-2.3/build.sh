#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=pjproject-2.3.tar.bz2
srcdir=pjproject-2.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
echo "#define PJSUA_MAX_CALLS    512" >> pjlib/include/pj/config_site.h

# remove the "samples" target from file pjsip-apps/build/Makefile

make dep && make clean && make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: Libraries for building embedded/non-embedded VoIP applications
 PJSIP is a free and open source multimedia communication library written in C
 language implementing standard based protocols such as SIP, SDP, RTP, STUN,
 TURN, and ICE. It combines signaling protocol (SIP) with rich multimedia
 framework and NAT traversal functionality into high level API that is
 portable and suitable for almost any type of systems ranging from desktops,
 embedded systems, to mobile handsets.
EOF
}

build
