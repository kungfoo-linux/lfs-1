#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=kdepimlibs-4.14.1.tar.xz
srcdir=kdepimlibs-4.14.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
	-DCMAKE_BUILD_TYPE=Release \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: kdelibs (>= 4.14.1), libxslt (>= 1.1.28), GPGME (>= 1.5.1), \
libical (>= 1.0), Akonadi (>= 1.13.0), cyrus-sasl (>= 2.1.26), \
Boost (>= 1.56.0), QJson (>= 0.8.1)
Recommends: OpenLDAP-client (>= 2.4.39)
Suggests: OpenSSL (>= 1.0.1i)
Description: the common library for KDE PIM applications
EOF
}

build
