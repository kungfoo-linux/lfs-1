#!/bin/bash -e
. ../lfs.comm

# The Readline package is a set of libraries that offers command-line editing
# and histroy capabilities.

build_src() {
    srcfil=readline-6.3.tar.gz
    srcdir=readline-6.3

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    patch -Np1 -i $PATCHES/readline-6.3-upstream_fixes-2.patch

    # Reinstalling Readline will cause the old libraries to be moved to
    # <libraryname>.old. While this is normally not a problem, in some cases
    # it can trigger a linking bug in ldconfig. This can be avoided by
    # issuing the following two seds:
    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install

    ./configure --prefix=/usr \
        --docdir=/usr/share/doc/readline-6.3
    make SHLIB_LIBS=-lncurses
    make SHLIB_LIBS=-lncurses install

    mv -v /usr/lib/lib{readline,history}.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) \
        /usr/lib/libreadline.so
    ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) \
        /usr/lib/libhistory.so
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3

    cd .. && rm -rf $srcdir
}

build
