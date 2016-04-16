#!/bin/bash -e
. ../lfs.comm

# The Kbd package contains key-table files and keyboard utilities.

build_src() {
    srcfil=kbd-2.0.2.tar.gz
    srcdir=kbd-2.0.2

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # The behavior of the Backspace and Delete keys is not consistent 
    # across the keymaps in the Kbd package. The following patch fixes 
    # this issue for i386 keymaps.
    # After patching, the Backspace key generates the character with 
    # code 127, and the Delete key generates a well-known escape sequence.
    patch -Np1 -i $PATCHES/kbd-2.0.2-backspace-1.patch

    # Remove the redundant resizecons program (it requires the defunct 
    # svgalib to provide the video mode files - for normal use setfont 
    # sizes the console appropriately) together with its manpage. 
    sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

    PKG_CONFIG_PATH=/tools/lib/pkgconfig \
        ./configure --prefix=/usr \
        --disable-vlock

    make -j$JOBS
    make install

    mkdir -v /usr/share/doc/kbd-2.0.2
    cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.2

    cd .. && rm -rf $srcdir
}

build
