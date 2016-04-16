#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=qca-2.0.3.tar.bz2
srcdir=qca-2.0.3
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i '217s@set@this->set@' src/botantools/botan/botan/secmem.h

./configure --prefix=/usr \
	--no-separate-debug-info \
	--certstore-path=/etc/ssl/ca-bundle.crt
make
make INSTALL_ROOT=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Qt4 (>= 4.8.6), CA (>= 7.6), Which (>= 2.20)
Description: Qt Cryptographic Architecture
 Qca aims to provide a straightforward and cross-platform crypto API, using Qt
 datatypes and conventions. Qca separates the API from the implementation,
 using plugins known as Providers.
EOF
}

build
