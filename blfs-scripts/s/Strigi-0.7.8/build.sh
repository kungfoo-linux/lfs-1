#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=strigi-0.7.8.tar.bz2
srcdir=strigi-0.7.8
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i "s/BufferedStream :/STREAMS_EXPORT &/" \
	libstreams/include/strigi/bufferedstream.h

mkdir -pv build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr \
	-DCMAKE_INSTALL_LIBDIR=lib \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_CLUCENE=OFF \
	-DENABLE_CLUCENE_NG=OFF \
	..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Recommends: DBus (>= 1.8.8), Qt4 (>= 4.8.6), FFmpeg (>= 2.3.3), \
Exiv2 (>= 0.24), libxml2 (>= 2.9.1)
Description: Lightweight and fast desktop search engine
 .
 [deepfind]
 is a utility for searching for filenames in compressed archives like tar,
 cpio, and zip.
 .
 [deepgrep]
 is a utility for searching compressed archives like tar, cpio, and zip.
 .
 [rdfindexer]
 manages and performs indexing of the RDF data for entities present on your
 site.
 .
 [strigiclient]
 is a Qt4 client (GUI) for the Strigi Desktop Search software.
 .
 [strigicmd]
 is a program for creating and querying indices.
 .
 [strigidaemon]
 is a daemon program for maintaining indices.
 .
 [xmlindexer]
 indexes XML documents.
EOF
}

build
