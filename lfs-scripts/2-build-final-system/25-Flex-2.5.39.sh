#!/bin/bash -e
. ../lfs.comm

# The Flex package contains a utility for generating programs that recognize
# patterns in text.

build_src() {
    srcfil=flex-2.5.39.tar.bz2
    srcdir=flex-2.5.39

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # First, skip running three regression tests that require Bison:
    sed -i -e '/test-bison/d' tests/Makefile.in

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/flex-2.5.39
    make -j$JOBS
    make check
    make install

    # A few programs do not know about flex yet and try to run its
    # predecessor, lex. To support those programs, create a symbolic link
    # named lex that runs flex in lex emulation mode:
    ln -sv flex /usr/bin/lex

    cd .. && rm -rf $srcdir
}

build
