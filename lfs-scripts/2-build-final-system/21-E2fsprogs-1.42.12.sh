#!/bin/bash -e
. ../lfs.comm

# The E2fsprogs package contains the utilities for handling the ext2 file
# system. It also supports the ext3 and ext4 journaling file systems.

build_src() {
    srcfil=e2fsprogs-1.42.12.tar.gz
    srcdir=e2fsprogs-1.42.12

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    mkdir -pv build && cd build

    LIBS=-L/tools/lib \
    CFLAGS=-I/tools/include \
    PKG_CONFIG_PATH=/tools/lib/pkgconfig \
    ../configure --prefix=/usr \
        --bindir=/bin \
        --with-root-prefix="" \
        --enable-elf-shlibs \
        --disable-libblkid \
        --disable-libuuid \
        --disable-uuidd \
        --disable-fsck
    make -j$JOBS
    make install
    make install-libs

    chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info /usr/share/info
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

    cd ../.. && rm -rf $srcdir
}

build
