#!/bin/bash -e
. ../../blfs.comm

gen_pkg_cfg() {
mkdir -pv $BUILDDIR/usr/lib/pkgconfig
cat > $BUILDDIR/usr/lib/pkgconfig/mad.pc << "EOF"
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: mad
Description: MPEG audio decoder
Requires:
Version: 0.15.1b
Libs: -L${libdir} -lmad
Cflags: -I${includedir}
EOF
}

build_src() {
srcfil=libmad-0.15.1b.tar.gz
srcdir=libmad-0.15.1b
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

patch -Np1 -i $BLFSSRC/$PKGLETTER/$CURDIR/libmad-0.15.1b-fixes-1.patch
sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac
touch NEWS AUTHORS ChangeLog
autoreconf -fi

./configure --prefix=/usr \
	--disable-static
make
make DESTDIR=$BUILDDIR install

gen_pkg_cfg

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: MPEG audio decoder library
 libmad is a high-quality MPEG audio decoder capable of 24-bit output.
EOF
}

build
