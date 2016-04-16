#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=graphite2-1.2.4.tgz
srcdir=graphite2-1.2.4
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
make DESTDIR=$BUILDDIR install

cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: font rendering engine for complex scripts
 Graphite2 is a rendering engine for graphite fonts. These are TrueType fonts
 with additional tables containing smart rendering information and were
 originally developed to support complex non-Roman writing systems. They may
 contain rules for e.g. ligatures, glyph substitution, kerning, justification
 - this can make them useful even on text written in Roman writing systems
 such as English. Note that firefox provides an internal copy of the graphite
 engine and cannot use a system version, but it too should benefit from the
 availability of graphite fonts.
 .
 [comparerender]
 is a test and benchmarking tool.
 .
 [gr2fonttest]
 is a diagnostic console tool for graphite fonts.
 .
 [libgraphite2.so]
 is a rendering engine for graphite fonts.
EOF
}

build
