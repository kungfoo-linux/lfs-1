#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libmpeg2-0.5.1.tar.gz
srcdir=libmpeg2-0.5.1
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/static const/static/' libmpeg2/idct_mmx.c

./configure --prefix=/usr
make
make DESTDIR=$BUILDDIR install

install -v -m755 -d $BUILDDIR/usr/share/doc/mpeg2dec-0.5.1
install -v -m644 README doc/libmpeg2.txt \
	$BUILDDIR/usr/share/doc/mpeg2dec-0.5.1

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: Xorg-lib (>= 7.7), SDL (>= 1.2.15)
Description: MPEG-2 decoder libraries
EOF
}

build
