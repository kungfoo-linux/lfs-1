#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=xmlto-0.0.26.tar.bz2
srcdir=xmlto-0.0.26
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: docbook-xml (>= 4.5), docbook-xsl (>= 1.78.1), libxslt (>= 1.1.28), \
fop (>= 1.1), Lynx (>= 2.8.8rel.2)
Description: XML-to-any converter
 xmlto is a front-end to an XSL toolchain. It chooses an appropriate
 stylesheet for the conversion you want and applies it using an external XSLT
 processor (currently, only xsltproc is supported). It also performs any
 necessary post-processing.
 .
 It supports converting from DocBook XML to DVI, XSL-FO, HTML and XHTML (one
 or multiple pages), epub, manual page, PDF, PostScript and plain text. It
 also supports converting from XSL-FO to DVI, PDF and PostScript.
 .
 DVI output requires dblatex or PassiveTeX. Other formats can be produced with
 any of the supported toolchains - dblatex, PassiveTeX or docbook-xsl/fop (but
 may require some extensions).
 .
 [xmlif]
 is a conditional processing instructions for XML.
 .
 [xmlto]
 applies an XSL stylesheet to an XML document.
EOF
}

build
