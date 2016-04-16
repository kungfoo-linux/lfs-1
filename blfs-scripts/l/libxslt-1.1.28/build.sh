#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libxslt-1.1.28.tar.gz
srcdir=libxslt-1.1.28
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libxml2 (>= 2.9.1), docbook-xml (>= 4.5), docbook-xsl (>= 1.78.1), \
libgcrypt (>= 1.6.2), Python2 (>= 2.7.8)
Description: library providing the GNOME XSLT engine
 The libxslt package contains XSLT libraries used for extending libxml2
 libraries to support XSLT files.
 .
 [xslt-config]
 is used to find out the pre-processor, linking and compiling flags necessary
 to use the libxslt libraries in 3rd-party programs.
 .
 [xsltproc]
 is used to apply XSLT stylesheets to XML documents.
 .
 [libexslt.so]
 is used to provide extensions to XSLT functions.
 .
 [libxslt.so]
 provides extensions to the libxml2 libraries to parse files that use the XSLT
 format.
EOF
}

build
