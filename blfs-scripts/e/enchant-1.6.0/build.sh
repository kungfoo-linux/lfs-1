#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=enchant-1.6.0.tar.gz
srcdir=enchant-1.6.0
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
Depends: GLib (>= 2.40.0), Aspell (>= 0.60.6.1)
Description: an enchanting spell checking library
 The enchant package provide a generic interface into various existing spell
 checking libraries.
 .
 [enchant]
 is a spellchecker
 .
 [enchant-lsmod]
 lists available backends, languages, and dictionaries.
 .
 [libenchant.{so,a}]
 contains spell checking interface API functions. 
EOF
}

build
