#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=dblatex-0.3.5.tar.bz2
srcdir=dblatex-0.3.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

echo "OK"
exit 0

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Python2 (>= 2.7.8), docbook-xml (>= 4.5)
Description: DocBook to LaTeX Publishing
 DocBook to LaTeX Publishing transforms your SGML/XML DocBook documents to
 DVI, PostScript or PDF by translating them in pure LaTeX as a first process.
 MathML 2.0 markups are supported too. It started as a clone of DB2LaTeX.
EOF
}

build
