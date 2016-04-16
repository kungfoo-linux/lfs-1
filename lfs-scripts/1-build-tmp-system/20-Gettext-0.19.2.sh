#!/bin/bash -e
. ../lfs.comm

# The Gettext package contains utilities for internationzlization and
# localization. These allow programs to be compiled with NLS (Native
# Language Support), enabling them to output messages in the user's
# native language.

build_src() {
    srcfil=gettext-0.19.2.tar.xz
    srcdir=gettext-0.19.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir/gettext-tools

    EMACS="no" ./configure --prefix=/tools --disable-shared
    make -C gnulib-lib
    make -C src msgfmt
    make -C src msgmerge
    make -C src xgettext
    cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

    cd ../.. && rm -rf $srcdir
}

build
