#!/bin/bash -e
. ../lfs.comm

# The Groff package contains programs for processing and formatting text.

build_src() {
    srcfil=groff-1.22.2.tar.gz
    srcdir=groff-1.22.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # Groff expects the environment variable PAGE to contain the default paper
    # size. For users in the United States, PAGE=letter is appropriate.
    # Elsewhere, PAGE=A4 may be more suitable. While the default paper size
    # is configured during compilation, it can be overridden later by echoing
    # either “A4” or “letter” to the /etc/papersize file.

    PAGE=A4 ./configure --prefix=/usr
    make -j$JOBS
    make install

    cd .. && rm -rf $srcdir
}

build
