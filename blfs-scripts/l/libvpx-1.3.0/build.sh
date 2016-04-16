#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libvpx-v1.3.0.tar.xz
srcdir=libvpx-v1.3.0
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

sed -i 's/cp -p/cp/' build/make/Makefile
chmod -v 644 vpx/*.h
mkdir ../libvpx-build
cd ../libvpx-build

../libvpx-v1.3.0/configure --prefix=/usr \
	--enable-shared \
	--disable-static
make
make DESTDIR=$BUILDDIR install

cleanup_src .. $srcdir
rm -rf libvpx-build
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Depends: yasm (>= 1.3.0)
Description: VP8 video codec
 This package, from the WebM project, provides the reference implementations
 of the VP8 Codec, used in most current html5 video, and of the
 next-generation VP9 Codec.
 .
 [vpxdec
 is the WebM Project VP8 and VP9 decoder.
 .
 [vpxenc]
 is the WebM project VP8 and VP9 encoder.
 .
 [libvpx.so]
 provides functions to use the VP8 and VP9 video codecs.
EOF
}

build
