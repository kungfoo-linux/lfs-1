#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=docbook-xsl-1.78.1.tar.bz2
srcdir=docbook-xsl-1.78.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/docbook-xsl-doc-1.78.1.tar.bz2 \
	--strip-components=1

install -v -m755 -d $BUILDDIR/usr/share/xml/docbook/xsl-stylesheets-1.78.1
cp -v -R VERSION common eclipse epub extensions fo highlighting html \
	htmlhelp images javahelp lib manpages params profiling \
	roundtrip slides template tests tools webhelp website \
	xhtml xhtml-1_1 \
	$BUILDDIR/usr/share/xml/docbook/xsl-stylesheets-1.78.1

ln -s VERSION $BUILDDIR/usr/share/xml/docbook/xsl-stylesheets-1.78.1/VERSION.xsl
install -v -m644 -D README $BUILDDIR/usr/share/doc/docbook-xsl-1.78.1/README.txt
install -v -m644 RELEASE-NOTES* NEWS* $BUILDDIR/usr/share/doc/docbook-xsl-1.78.1
cp -v -R doc/* $BUILDDIR/usr/share/doc/docbook-xsl-1.78.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: libxml2 (>= 2.9.1)
Description: stylesheets for processing DocBook XML to various output formats
 The DocBook XSL Stylesheets package contains XSL stylesheets. These are
 useful for performing transformations on XML DocBook files.
EOF
}

set_deb_def() {
POSTINST_FUNC_DEF='
populate_catalog() {
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog &&

xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
    /etc/xml/catalog
}
'

POSTINST_CONF_DEF='populate_catalog'
}

build
