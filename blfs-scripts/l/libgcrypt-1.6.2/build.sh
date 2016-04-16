#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libgcrypt-1.6.2.tar.bz2
srcdir=libgcrypt-1.6.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

# add "--with-capabilities" to enables libcap2 support
./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

install -v -dm755 $BUILDDIR/usr/share/doc/libgcrypt-1.6.2 &&
install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
        $BUILDDIR/usr/share/doc/libgcrypt-1.6.2

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libgpg-error (>= 1.13)
Suggests: libcap (>= 2.24), Pth (>= 2.0.7)
Description: a general-purpose cryptography library
 The libgcrypt package contains a general purpose crypto library based on the
 code used in GnuPG. The library provides a high level interface to
 cryptographic building blocks using an extendable and flexible API.
 .
 [libgcrypt.so] contains the cryptographic API functions. 
EOF
}

build
