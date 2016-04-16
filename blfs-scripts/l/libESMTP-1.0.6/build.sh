#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libesmtp-1.0.6.tar.bz2
srcdir=libesmtp-1.0.6
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: OpenSSL (>= 1.0.1i)
Description: a SMTP client library
 The libESMTP package contains the libESMTP libraries which are used by some
 programs to manage email submission to a mail transport layer.
 .
 [libesmtp-config]
 displays version information and the options used to compile libESMTP.
 .
 [libesmtp.{so,a}]
 is used to manage submission of electronic mail to a Mail Transport Agent.
 .
 [libesmtp SASL plugins]
 are used to integrate libesmtp with SASL authentication. 
EOF
}

build
