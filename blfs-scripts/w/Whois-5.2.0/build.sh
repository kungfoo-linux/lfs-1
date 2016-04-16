#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=whois_5.2.0.tar.xz
srcdir=whois-5.2.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

make
make BASEDIR=$BUILDDIR prefix=/usr install-whois
make BASEDIR=$BUILDDIR prefix=/usr install-pos

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: intelligent WHOIS client
 This package provides a commandline client for the WHOIS (RFC 3912) protocol,
 which queries online servers for information such as contact details for
 domains and IP address assignments. It can intelligently select the
 appropriate WHOIS server for most queries.
EOF
}

build
