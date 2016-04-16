#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxml2-2.9.1.tar.gz
srcdir=libxml2-2.9.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--with-history
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8)
Description: library providing XML and HTML support
 The libxml2 package contains libraries and utilities used for parsing XML
 files.
 .
 [xml2-config]
 determines the compile and linker flags that should be used to compile and
 link programs that use libxml2.
 .
 [xmlcatalog]
 is used to monitor and manipulate XML and SGML catalogs.
 .
 [xmllint]
 parses XML files and outputs reports (based upon options) to detect errors in
 XML coding.
 .
 [libxml2.so]
 provides functions for programs to parse files that use the XML format.
EOF
}

build
