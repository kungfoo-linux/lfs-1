#!/bin/bash -e
. ../../blfs.comm

build_src() {
srcfil=libtirpc-0.2.5.tar.bz2
srcdir=libtirpc-0.2.5
tar -xf $BLFSSRC/$PKGLETTER/$CURDIR/$srcfil
cd $srcdir

./configure --prefix=/usr \
	--sysconfdir=/etc \
	--disable-static \
	--disable-gssapi
make
make DESTDIR=$BUILDDIR install

mkdir -pv $BUILDDIR/lib
mv -v $BUILDDIR/usr/lib/libtirpc.so.* $BUILDDIR/lib
ln -sfv ../../lib/libtirpc.so.1.0.10 $BUILDDIR/usr/lib/libtirpc.so

cleanup_src .. $srcdir
}

gen_control() {
cat > $DEBIANDIR/control << EOF
$PKGHDR
Description: transport-independent RPC library
  The libtirpc package contains libraries that support programs that use the
  Remote Procedure Call (RPC) API. It replaces the RPC, but not the NIS
  library entries that used to be in glibc.
  .
  [libtirpc.so] provides the Remote Procedure Call (RPC) API functions 
  required by other programs. 
EOF
}

build
