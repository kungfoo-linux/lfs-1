#!/bin/bash -e
. ../../blfs.comm

# The optional package Perl-5.20.0, Ncurses-5.9 and Flex-2.5.39 included
# in LFS-7.6.

build_src() {
srcfil=otp_src_17.4.tar.gz
srcdir=otp_src_17.4
srcfil_openssl=$BLFSSRC/o/OpenSSL-1.0.1i/openssl-1.0.1i.tar.gz
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir
tar -xf $srcfil_openssl

./configure --prefix=/opt/erlang-17.4 \
	--without-javac \
	--without-gs \
	--without-wx \
	--with-ssl=${PWD}/openssl-1.0.1i

jobs=`cat /proc/cpuinfo | grep "^processor" | wc -l`
make -j${jobs}
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: General-purpose programming language and runtime environment
 Erlang is a programming language used to build massively scalable soft
 real-time systems with requirements on high availability. Some of its uses
 are in telecoms, banking, e-commerce, computer telephony and instant
 messaging. Erlang's runtime system has built-in support for concurrency,
 distribution and fault tolerance.
 .
 OTP is set of Erlang libraries and design principles providing middle-ware to
 develop these systems. It includes its own distributed database, applications
 to interface towards other languages, debugging and release handling tools.
EOF
}

build
