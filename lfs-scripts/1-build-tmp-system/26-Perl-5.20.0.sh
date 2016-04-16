#!/bin/bash -e
. ../lfs.comm

# The Perl package contains the Practical Extraction and Report Language.

build_src() {
    srcfil=perl-5.20.0.tar.bz2
    srcdir=perl-5.20.0

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    sh Configure -des -Dprefix=/tools -Dlibs=-lm
    make -j$JOBS
    cp -v perl cpan/podlators/pod2man /tools/bin
    mkdir -pv /tools/lib/perl5/5.20.0
    cp -Rv lib/* /tools/lib/perl5/5.20.0

    cd .. && rm -rf $srcdir
}

build
