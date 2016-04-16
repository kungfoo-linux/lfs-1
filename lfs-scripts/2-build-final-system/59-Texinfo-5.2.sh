#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=texinfo-5.2.tar.xz
    srcdir=texinfo-5.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr
    make -j$JOBS
    make check
    make install

    # Optionally, install the components belonging in a TeX installation:
    make TEXMF=/usr/share/texmf install-tex

    pushd /usr/share/info
    rm -v dir
    for f in *
    do install-info $f dir 2>/dev/null
    done
    popd

    cd .. && rm -rf $srcdir
}

build
