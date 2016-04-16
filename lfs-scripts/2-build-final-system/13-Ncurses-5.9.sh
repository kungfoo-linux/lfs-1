#!/bin/bash -e
. ../lfs.comm

build_src() {
    srcfil=ncurses-5.9.tar.gz
    srcdir=ncurses-5.9

    tar -xf $LFSSRC/$srcfil && cd $srcdir

    ./configure --prefix=/usr \
        --mandir=/usr/share/man \
        --with-shared \
        --without-debug \
        --enable-pc-files \
        --enable-widec
    make -j$JOBS
    make install

    mv -v /usr/lib/libncursesw.so.5* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) \
        /usr/lib/libncursesw.so

    for lib in ncurses form panel menu ; do
        rm -vf                    /usr/lib/lib${lib}.so
        echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
        ln -sfv lib${lib}w.a      /usr/lib/lib${lib}.a
        ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
    done
    ln -sfv libncurses++w.a /usr/lib/libncurses++.a

    rm -vf                     /usr/lib/libcursesw.so
    echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
    ln -sfv libncurses.so      /usr/lib/libcurses.so
    ln -sfv libncursesw.a      /usr/lib/libcursesw.a
    ln -sfv libncurses.a       /usr/lib/libcurses.a

    mkdir -pv      /usr/share/doc/ncurses-5.9
    cp -v -R doc/* /usr/share/doc/ncurses-5.9

    cd .. && rm -rf $srcdir
}

build
