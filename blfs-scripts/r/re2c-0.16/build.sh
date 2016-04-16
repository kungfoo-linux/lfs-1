#!/bin/bash -e
. ../../blfs.comm

build_src() {
    srcfil=re2c-0.16.tar.gz
    srcdir=re2c-0.16
    tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
    cd $srcdir/re2c
    
    ./autogen.sh
    ./configure --prefix=/usr
    make $JOBS
    make DESTDIR=$BUILDDIR install
    
    cleanup_src ../.. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: tool for generating fast C-based recognizers
 re2c is a great tool for writing fast and flexible lexers. Unlike
 other such tools, re2c concentrates solely on generating efficient
 code for matching regular expressions. Not only does this singleness
 make re2c more suitable for a wider variety of applications, it
 allows us to generate scanners which approach hand-crafted ones in
 terms of size and speed.
EOF
}

build
