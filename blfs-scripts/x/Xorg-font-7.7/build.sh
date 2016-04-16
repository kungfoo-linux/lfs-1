#!/bin/bash -e
. ../../blfs.comm

build_src() {
filelst=$BLFSSRC/$PKGLETTER/$CURDIR/font-7.7.md5
for package in $(grep -v '^#' $filelst | awk '{print $2}')
do
    srcfil=$BLFSSRC/$PKGLETTER/$CURDIR/font/$package
    packagedir=${package%.tar.bz2}

    tar -xf $srcfil
    pushd $packagedir

    ./configure $XORG_CONFIG
    make
    make install
    make DESTDIR=$BUILDDIR install

    popd
    rm -rf $packagedir
done

install -v -d -m755 $BUILDDIR/usr/share/fonts
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF $BUILDDIR/usr/share/fonts/X11-OTF
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF $BUILDDIR/usr/share/fonts/X11-TTF
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: xcursor-themes (>= 1.0.4)
Description: the fonts for Xorg applications
 .
 [bdftruncate]
 generates a truncated BDF font from an ISO 10646-1 encoded BDF font.
 .
 [ucs2any]
 generates BDF fonts in any encoding from an ISO 10646-1 encoded BDF font.
EOF
}

build
