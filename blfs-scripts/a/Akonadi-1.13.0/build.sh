#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=akonadi-1.13.0.tar.bz2
srcdir=akonadi-1.13.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX  \
	-DCMAKE_BUILD_TYPE=Release \
	-DINSTALL_QSQLITE_IN_QT_PREFIX=TRUE \
	-Wno-dev \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: shared-mime-info (>= 1.3), Boost (>= 1.56.0), SQLite (>= 3.8.6)
Description: KDE Resources for PIM Storage Service
 Akonadi is an extensible cross-desktop storage service for PIM data and
 metadata providing concurrent read, write, and query access. It provides
 unique desktop-wide object identification and retrieval.
EOF
}

build
