#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libass-0.11.2.tar.xz
srcdir=libass-0.11.2
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--disable-static \
	--disable-harfbuzz \
	--disable-enca
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: FreeType (>= 2.5.3), FriBidi (>= 0.19.6), Fontconfig (>= 2.11.1)
Description: library for SSA/ASS subtitles rendering
 libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation
 Alpha/Substation Alpha) subtitle format that allows for more advanced
 subtitles than the conventional SRT and similar formats.
EOF
}

build
