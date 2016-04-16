#!/bin/bash -e
. ../../blfs.comm

build_src() {
filelst=$BLFSSRC/$PKGLETTER/$CURDIR/lib-7.7.md5
for package in $(grep -v '^#' $filelst | awk '{print $2}')
do
    srcfil=$BLFSSRC/$PKGLETTER/$CURDIR/lib/$package
    packagedir=${package%.tar.bz2}

    tar -xf $srcfil
    pushd $packagedir

    case $packagedir in
        libXfont-[0-9]* )
            ./configure $XORG_CONFIG --disable-devel-docs
            ;;
        libXt-[0-9]* )
            ./configure $XORG_CONFIG --with-appdefaultdir=/etc/X11/app-defaults
            ;;
        * )
            ./configure $XORG_CONFIG
            ;;
    esac

    make
    make install
    make DESTDIR=$BUILDDIR install

    popd
    rm -rf $packagedir
    /sbin/ldconfig
done
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Fontconfig (>= 2.11.1), libxcb (>= 1.11)
Description: library routines used within all X Window applications
 The Xorg protocol headers provide the header files required to build the
 system, and to allow other applications to build against the installed X
 Window system.
EOF
}

build
