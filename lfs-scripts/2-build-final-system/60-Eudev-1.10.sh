#!/bin/bash -e
. ../lfs.comm

# The Eudev package contains programs for dynamic creation of device nodes.

build_src() {
    srcfil=eudev-1.10.tar.gz
    srcdir=eudev-1.10

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    # fix a test script:
    sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl

    BLKID_CFLAGS=-I/tools/include \
    BLKID_LIBS='-L/tools/lib -lblkid' \
    ./configure --prefix=/usr \
        --bindir=/sbin \
        --sbindir=/sbin \
        --libdir=/usr/lib \
        --sysconfdir=/etc \
        --libexecdir=/lib \
        --with-rootprefix= \
        --with-rootlibdir=/lib \
        --enable-split-usr \
        --enable-libkmod \
        --enable-rule_generator \
        --enable-keymap \
        --disable-introspection \
        --disable-gudev \
        --disable-gtk-doc-html \
        --with-firmware-path=/lib/firmware
    make -j$JOBS

    mkdir -pv /lib/{firmware,udev}
    mkdir -pv /lib/udev/rules.d
    mkdir -pv /etc/udev/rules.d

    set +e; make check; set -e
    make install

    tar -xvf $LFSSRC/eudev-1.10-manpages.tar.bz2 -C /usr/share
    tar -xvf $LFSSRC/udev-lfs-20140408.tar.bz2
    make -f udev-lfs-20140408/Makefile.lfs install

    cd .. && rm -rf $srcdir
}

build
