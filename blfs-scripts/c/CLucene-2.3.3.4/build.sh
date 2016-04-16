#!/bin/bash -e
. ../../blfs.comm

build_src() {
# For build this package, need the Boost's header files.

srcfil=clucene-core-2.3.3.4.tar.gz
srcdir=clucene-core-2.3.3.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/clucene-2.3.3.4-contribs_lib-1.patch

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DBUILD_CONTRIBS_LIB=ON ..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: a C++ port of Lucene
 CLucene is a C++ version of Lucene, a high performance text search engine.
EOF
}

build
